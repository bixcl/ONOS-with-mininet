# control mininet hostes using ONOS - docker version.
for more information read "Advanced Topics in Information Security-final project.docx" file
<a id="readme-top"></a>
<!--
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Unlicense License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
-->


<!-- PROJECT LOGO 
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Best-README-Template</h3>

  <p align="center">
    An awesome README template to jumpstart your projects!
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template">View Demo</a>
    &middot;
    <a href="https://github.com/othneildrew/Best-README-Template/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    &middot;
    <a href="https://github.com/othneildrew/Best-README-Template/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>
-->


<!-- TABLE OF CONTENTS 
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>
-->


<!-- ABOUT THE PROJECT -->
## About The Project

THis project will explain how to control mininet hosts using ONOS sdn controller the docker version.
We tried for 3 week to configure diffrent sdn controller to control mininet, but these controller needs more time and more tools to download on linux machine, so insted of bothering our self with all these unnessiccirly details, we descide to go with docker version which make the process easyier than before.<br>

this project will offer full commands that you can use in linux that will make onos control mininet devices. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>



### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* [![Python]][python-url]
* [![docker]][docker-url]
* [![json]][json-url]
* [![ubuntu]][ubuntu-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started
#### installing docker
first we need to update our linux machine, install docker, and start it, these comands will do the job.

  ```sh
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker $USER

  ```

### make ONOS run
this command for making onos sdn controller run on port 8101.

   ```sh
    docker run -d --name onos \
    -p 8181:8181 -p 6653:6653 -p 8101:8101 \
    onosproject/onos

   ```

3. after starting docker successfuly we need to connect the onos through ssh in order to install the features we want
   
   ```sh
   ssh -p 8101 onos@localhost
   ```

   the ssh password for the user onos is <b>rocks</b>.

5. after starting ssh succeflly we need to install these 3 feature
   ```sh
      app activate org.onosproject.openflow # allow web interface
      app activate org.onosproject.fwd # allow forword
      app activate org.onosproject.acl # allow Access controll list

   ```
6. now the onos sdn web page should be ready to access.<br>
use this link in ur linux machine to access it : http://localhost:8181/onos/ui <br>
username: onos <br>
password: rocks

<sub>for images read the word file</sub>

7. installing configuring mininet 

   ```sh
    sudo apt install mininet -y
   ```
    do this step in order to start openvswitch process, you need to do it again if you shutdown the system

   ```sh
    sudo service openvswitch-switch start
    sudo /etc/init.d/openvswitch-switch start
   ```

8. Running mininet.
   ```sh
     sudo mn --topo tree,2,2 --mac --switch ovs,protocols=OpenFlow13 --controller remote,ip=127.0.0.1:6653
   ```

   <b>make sure its running on ur local host and its running on 6653 port.</b><br>
   <h6>if u update the onos web page u will see that the devices is updated</h6><br>
   try to ping all and see the diffrence after we apply the rules

   ```mininet
   mininet>pingall
   ```
8. now inside new terminal write this command, this command will deny icmp(ping) packets betwen h1 and h2
  ```sh
    curl -X POST -H "Content-Type: application/json" -u onos:rocks \
  http://localhost:8181/onos/v1/acl/rules \
  -d '{
    "srcIp": "10.0.0.1/32", 
    "dstIp": "10.0.0.2/32", 
    "ipProto": "ICMP", 
    "action": "DENY",
    "priority": 40000
  }'

  ```

9. this command you can use it to check if the rule successfully added to onos, and check the lists of rules.

   ```sh
      curl -u onos:rocks http://localhost:8181/onos/v1/acl/rules
    ```
   
10. now this command you can use it to delet any rules by simply compy the rule id and put it at the end of this command

   ```sh
      curl -X DELETE -u onos:rocks http://localhost:8181/onos/v1/acl/rules/{ruleId} # keep the bracket
  ```

11. this is last step which is to check if our rule is working, simply return back to mininet page and pingall again.
    
    ```mininet
    mininet> pingall
    ```


12. now i will give some less importent command you maybe need to know<br>
  to stop onos

```sh
docker stop onos # than run the docker first command again to run it again
```

now this used to restart ONOS

```sh
docker restart onos
```

use this command if you face problem in onos, it will delete all configureation you make in onos, so you need to configure it again, just rebeat the process

```sh
docker stop onos
docker rm onos
```

this command used to enter onos /bin/bash directory and configuret from there

```bash
docker exec -it onos /bin/bash
```

another user to connect to onos using ssh is karaf

```bash
ssh -p 8101 karaf@localhost
password: karaf 
```

   
<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP 
## Roadmap

- [x] Add Changelog
- [x] Add back to top links
- [ ] Add Additional Templates w/ Examples
- [ ] Add "components" document to easily copy & paste sections of the readme
- [ ] Multi-language Support
    - [ ] Chinese
    - [ ] Spanish

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>
-->


<!-- CONTRIBUTING 
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Top contributors:

<a href="https://github.com/othneildrew/Best-README-Template/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=othneildrew/Best-README-Template" alt="contrib.rocks image" />
</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

-->

<!-- LICENSE 
## License

Distributed under the Unlicense License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

-->

<!-- CONTACT -->
## Contact

Ali Sulaiman - [@ialibxl](https://twitter.com/ialibxl)

Project Link: [https://github.com/bixcl/ONOS-with-mininet](https://github.com/bixcl/ONOS-with-mininet)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS 
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Malven's Flexbox Cheatsheet](https://flexbox.malven.co/)
* [Malven's Grid Cheatsheet](https://grid.malven.co/)
* [Img Shields](https://shields.io)
* [GitHub Pages](https://pages.github.com)
* [Font Awesome](https://fontawesome.com)
* [React Icons](https://react-icons.github.io/react-icons/search)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
-->

[python-url]: https://www.python.org
[docker-url]: https://www.docker.com/
[json-url]: www.json.org
[ubuntu-url]: https://ubuntu.com/
<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links 

[python]: [https://www.python.org/static/img/python-logo.png](https://cdn.iconscout.com/icon/free/png-256/free-python-logo-icon-download-in-svg-png-gif-file-formats--technology-social-media-vol-5-pack-logos-icons-2945099.png?f=webp&w=100)

[docker]: https://images.crunchbase.com/image/upload/c_pad,h_256,w_256,f_auto,q_auto:eco,dpr_1/ywjqppks5ffcnbfjuttq
[json]:https://cdn.iconscout.com/icon/free/png-256/free-json-logo-icon-download-in-svg-png-gif-file-formats--brand-development-tools-pack-logos-icons-226010.png?f=webp&w=256


[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
-->
