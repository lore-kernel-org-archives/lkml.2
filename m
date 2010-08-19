Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0HSBaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 21:30:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55060 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0HSBaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 21:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rvf2SLbbDA3ZFSGBa5CUA74k26s4wOdn+LUTPK41Pt0XLaH1tn9vyTXiiRtYtM9co9
         e3WYv6vGswCv3DNj7Jgnr2Q0tNwpqzghkpYqET16tRZIE++TndmdZTZrkiF6ZY3asdtr
         AW9Y/N6xDSbDtXRXmX+3sWsBWjEg55h/rOJoE=
Message-ID: <4C6C8913.2000007@gmail.com>
Date: Thu, 19 Aug 2010 09:29:55 +0800
From: "Mr. Teo En Ming (Zhang Enming) of Singapore" 
	<space.time.universe@gmail.com>
Reply-To: space.time.universe@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Han, Weidong" <weidong.han@intel.com>,
        "space.time.universe@gmail.com" <space.time.universe@gmail.com>,
        "teoenming@hotmail.com" <teoenming@hotmail.com>,
        zhang_enming@lavabit.com
Subject: Re: [Xen-devel] Xen patches merged to upstream Linux 2.6.36, plans
  for 2.6.37?
References: <20100815160904.GM2804@reaktio.net> <4C68CCCD.5060303@gmail.com> <4C693557.2010005@gmail.com> <20100816130401.GL2804@reaktio.net> <4C696AFC.7060504@gmail.com> <20100816165548.GQ2804@reaktio.net> <4C69740F.8060405@gmail.com> <4C69C988.1020803@gmail.com> <20100817055724.GZ2804@reaktio.net> <4C6B6EFC.9090805@gmail.com>
In-Reply-To: <4C6B6EFC.9090805@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Pasi, Xen developers, and Han Weidong of Intel Corporation,

I have made a video demonstrating Intel IGD (primary VGA adapter) VGA 
passthrough to Windows XP Home Edition HVM domU virtual machine with Xen 
4.0.1-rc6-pre and Jeremy Fitzhardinge's pv-ops dom0 kernel 2.6.32.19 on 
18 August 2010 Wednesday at 5:38 P.M. Singapore Time. The video 
demonstrates a very long time lag (approximately 3-5 minutes) before 
Windows XP Home Edition HVM virtual machine starts booting after 
executing the command "xm create winxphome32". WinXP Home Edition HVM 
domU is unable to load the SoundMAX audio driver and re-detects Intel HD 
Audio, and eventually crashes with a Blue Screen of Death (BSOD).

I have just finished uploading the video to my Youtube account (19 
August 2010 Thursday 9:16 A.M. Singapore Time).

Please watch my video at the following link/URL:

http://www.youtube.com/watch?v=mL4C_InwZH8

At the time of this writing, there are 21 uploaded videos in my Youtube 
account.

Please visit

http://www.youtube.com/user/enmingteo

Thank you very much.

Yours sincerely,

Mr. Teo En Ming (Zhang Enming)
Citizenship: Singapore Citizen/Singaporean
Facebook account: Teo En Ming (Zhang Enming)
Facebook link:http://www.facebook.com/profile.php?id=100000750083982
Facebook photos:
http://www.facebook.com/profile.php?id=100000750083982#!/profile.php?id=100000750083982&v=photos  <http://www.facebook.com/profile.php?id=100000750083982#%21/profile.php?id=100000750083982&v=photos>
Facebook videos:
http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137  <http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137>
Mobile Phone (Starhub pre-paid): +65-8369-2618
Windows Live Messenger:teoenming at hotmail.com  <https://admin.fedoraproject.org/mailman/listinfo/users>
Location: Bedok Reservoir Road, Singapore
ZIP: 470103
My Open Letter (Plea for Medical Help/Assistance) to World Leaders:-
http://lists.mcs.anl.gov/pipermail/mpich-discuss/2010-August/007693.html
http://lists.fedoraproject.org/pipermail/users/2010-August/380213.html
http://mythtv.org/pipermail/mythtv-users/2010-August/294733.html





On 08/18/2010 01:26 PM, Mr. Teo En Ming (Zhang Enming) of Singapore wrote:
> Dear All,
>
> I must apologize to have to say that Intel IGD VGA passthrough to my 
> Windows XP Home Edition HVM domU did not succeed/work with Xen 
> 4.0.1-rc6-pre hypervisor and Jeremy Fitzhardinge's pv-ops dom0 kernel 
> 2.6.32.19 in my earlier email. I was not patient enough.
>
> This morning, on 18 August 2010 Wednesday, at about 11:16+ A.M. 
> Singapore Time, I have just added a section to my /boot/grub/grub.conf 
> to enable serial console for Xen 4.0.1-rc6-pre and pv-ops dom0 kernel 
> 2.6.32.19 for kernel debugging/troubleshooting.
>
> Here is my updated /boot/grub/grub.conf.
>
> Section 8: My /boot/grub/grub.conf configuration
> ==============================
>
> # grub.conf generated by anaconda
> #
> # Note that you do not have to rerun grub after making changes to this 
> file
> # NOTICE:  You have a /boot partition.  This means that
> #          all kernel and initrd paths are relative to /boot/, eg.
> #          root (hd0,0)
> #          kernel /vmlinuz-version ro 
> root=/dev/mapper/vg_fedora11_host-lv_root
> #          initrd /initrd-version.img
> #boot=/dev/sda
> default=6
> timeout=100
> splashimage=(hd0,0)/grub/splash.xpm.gz
> hiddenmenu
> title Fedora (2.6.32.19-xen-enming.teo) with Serial Console
>         root (hd0,0)
> #       kernel /vmlinuz-2.6.32.19-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #       initrd /initrd-2.6.32.19-xen-enming.teo.img
>         kernel /xen.gz dom0_mem=1024M iommu=1 loglvl=all 
> guest_loglvl=all sync_console console_to_ring com1=115200,8n1 console=com1
>         module /vmlinuz-2.6.32.19-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0 
> console=hvc0 earlyprintk=xen nomodeset
>         module /initrd-2.6.32.19-xen-enming.teo.img
> title Fedora (2.6.32.19-xen-enming.teo)
>     root (hd0,0)
> #    kernel /vmlinuz-2.6.32.19-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #    initrd /initrd-2.6.32.19-xen-enming.teo.img
>         kernel /xen.gz dom0_mem=1024M iommu=1
>     module /vmlinuz-2.6.32.19-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0 nomodeset
>     module /initrd-2.6.32.19-xen-enming.teo.img
> title Fedora (2.6.31.5-xen-enming.teo)
>     root (hd0,0)
> #    kernel /vmlinuz-2.6.31.5-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #    initrd /initrd-2.6.31.5-xen-enming.teo.img
>     kernel /xen.gz dom0_mem=1024M iommu=1
>     module /vmlinuz-2.6.31.5-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0 nomodeset
>     module /initrd-2.6.31.5-xen-enming.teo.img
> title Fedora (2.6.31.4-xen-enming.teo)
>     root (hd0,0)
> #    kernel /vmlinuz-2.6.31.4-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #    initrd /initrd-2.6.31.4-xen-enming.teo.img
>     kernel /xen.gz dom0_mem=1024M iommu=1
>     module /vmlinuz-2.6.31.4-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0 nomodeset
>     module /initrd-2.6.31.4-xen-enming.teo.img
> title Fedora (2.6.31.1-xen-enming.teo)
>     root (hd0,0)
> #    kernel /vmlinuz-2.6.31.1-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #    initrd /initrd-2.6.31.1-xen-enming.teo.img
>     kernel /xen.gz dom0_mem=1024M iommu=1
>     module /vmlinuz-2.6.31.1-xen-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0 nomodeset
>     module /initrd-2.6.31.1-xen-enming.teo.img
> title Fedora (2.6.31-enming.teo)
>     root (hd0,0)
>     kernel /vmlinuz-2.6.31-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
>     initrd /initrd-2.6.31-enming.teo.img
> title Fedora (2.6.30.5-enming.teo)
>     root (hd0,0)
>     kernel /vmlinuz-2.6.30.5-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
>     initrd /initrd-2.6.30.5-enming.teo.img
> title Fedora (2.6.18.8-enming.teo)
>     root (hd0,0)
> #    kernel /vmlinuz-2.6.18.8-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #    initrd /initrd-2.6.18.8-enming.teo.img
>     kernel /xen.gz dom0_mem=1024M iommu=1
>     module /vmlinuz-2.6.18.8-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root
>     module /initrd-2.6.18.8-enming.teo.img
> title Fedora (2.6.31-rc6-enming.teo) with Serial Console
>         root (hd0,0)
> #       kernel /vmlinuz-2.6.31-rc6-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #       initrd /initrd-2.6.31-rc6-enming.teo.img
>         kernel /xen.gz dom0_mem=1024M iommu=1 
> iommu_inclusive_mapping=1 com1=115200,8n1 console=com1
> #       module /vmlinuz-2.6.31-rc6-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root selinux=0 xencons=ttyS0 
> console=ttyS0,115200
>     module /vmlinuz-2.6.31-rc6-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root selinux=0 console=hvc0 
> earlyprintk=xen
>         module /initrd-2.6.31-rc6-enming.teo.img
> title Fedora (2.6.30-rc3-enming.teo-tip) with Serial Console
>         root (hd0,0)
> #       kernel /vmlinuz-2.6.30-rc3-enming.teo-tip ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #       initrd /initrd-2.6.30-rc3-enming.teo-tip.img
>         kernel /xen.gz dom0_mem=1024M iommu=1 
> iommu_inclusive_mapping=1 com1=115200,8n1 console=com1
> #       module /vmlinuz-2.6.30-rc3-enming.teo-tip ro 
> root=/dev/mapper/vg_fedora11_host-lv_root selinux=0 xencons=ttyS0 
> console=ttyS0,115200
>     module /vmlinuz-2.6.30-rc3-enming.teo-tip ro 
> root=/dev/mapper/vg_fedora11_host-lv_root selinux=0 console=hvc0 
> earlyprintk=xen
>         module /initrd-2.6.30-rc3-enming.teo-tip.img
>
> title Fedora (2.6.31-rc6-enming.teo)
>     root (hd0,0)
> #    kernel /vmlinuz-2.6.31-rc6-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #    initrd /initrd-2.6.31-rc6-enming.teo.img
>     kernel /xen.gz dom0_mem=1024M iommu=1
>     module /vmlinuz-2.6.31-rc6-enming.teo ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0 nomodeset
>     module /initrd-2.6.31-rc6-enming.teo.img
> title Fedora (2.6.30-rc3-enming.teo-tip)
>     root (hd0,0)
> #    kernel /vmlinuz-2.6.30-rc3-enming.teo-tip ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
> #    initrd /initrd-2.6.30-rc3-enming.teo-tip.img
>     kernel /xen.gz dom0_mem=1024M iommu=1
>     module /vmlinuz-2.6.30-rc3-enming.teo-tip ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0 nomodeset
>     module /initrd-2.6.30-rc3-enming.teo-tip.img
> title Fedora (2.6.29.4-167.fc11.x86_64)
>     root (hd0,0)
>     kernel /vmlinuz-2.6.29.4-167.fc11.x86_64 ro 
> root=/dev/mapper/vg_fedora11_host-lv_root rhgb quiet selinux=0
>     initrd /initrd-2.6.29.4-167.fc11.x86_64.img
>
>
>
> Before I go any further, let me reproduce my own custom Linux shell 
> scripts here.
>
> Section 9: My Linux shell script start-windows
> =============================
>
> #!/bin/sh
>
> set -x
>
> # Stops the BOINC Core Client
> service boinc-client stop
>
> # Stops the Snort NIDS
> service snort stop
>
> # Stops barnyard
> service barnyard stop
>
> # Stops NTOP
> service ntop stop
>
> # Stops OSSEC HIDS
> service ossec stop
>
> # Passthrough NVIDIA graphics card
> #/etc/xen/scripts/passthru-nvidia.sh
> # Passthrough IGD
> /etc/xen/scripts/passthru-igd.sh
> # Passthrough Firewire port
> /etc/xen/scripts/passthru-firewire.sh
> # Passthrough Audio Controller
> /etc/xen/scripts/passthru-audio.sh
>
> ls -ltr /sys/bus/pci/drivers/pci-stub/
> sleep 5
>
> # Start Windows XP guest domain
> xm create winxphome32
>
> Section 10: My Linux shell script /etc/xen/scripts/passthru-igd.sh
> ========================================
>
> #!/bin/sh
>
> set -x
>
> echo "8086 2e12" > /sys/bus/pci/drivers/pci-stub/new_id
> echo "0000:00:02.0" > /sys/bus/pci/devices/0000:00:02.0/driver/unbind
> echo "0000:00:02.0" > /sys/bus/pci/drivers/pci-stub/bind
>
> Section 11: My Linux shell script /etc/xen/scripts/passthru-firewire.sh
> ===========================================
>
> #!/bin/sh
>
> set -x
>
> echo "11c1 5811" > /sys/bus/pci/drivers/pci-stub/new_id
> echo "0000:02:01.0" > /sys/bus/pci/devices/0000:02:01.0/driver/unbind
> echo "0000:02:01.0" > /sys/bus/pci/drivers/pci-stub/bind
>
> #Unload firewire driver
> rmmod firewire_ohci
> rmmod firewire_core
>
> Section 12: My Linux shell script /etc/xen/scripts/passthru-audio.sh
> ==========================================
>
> #!/bin/sh
>
> set -x
>
> echo "8086 3a6e" > /sys/bus/pci/drivers/pci-stub/new_id
> echo "0000:00:1b.0" > /sys/bus/pci/devices/0000:00:1b.0/driver/unbind
> echo "0000:00:1b.0" > /sys/bus/pci/drivers/pci-stub/bind
>
> rmmod snd_hda_intel
>
> Section 13: My Microsoft Windows XP Home Edition 32-bit HVM domU Guest 
> Operating System Configuration File
> ======================================================================
>
> #import os, re
> #arch = os.uname()[4]
> #if re.search('64', arch):
> #    arch_libdir = 'lib64'
> #else:
> #    arch_libdir = 'lib'
>
> kernel = "/usr/lib/xen/boot/hvmloader"
> builder='hvm'
> memory = 3072
>
> # Should be at least 2KB per MB of domain memory, plus a few MB per vcpu.
> #shadow_memory = 8
> name = "winxphome32"
> vif = [ 'bridge=eth0' ]
> acpi = 1
> apic = 1
> disk = [ 'phy:/dev/virtualmachines/winxphome32,hda,w', 
> 'phy:/dev/sr0,hdc:cdrom,r' ]
>
> #device_model = '/usr/' + arch_libdir + '/xen/bin/qemu-dm'
> #device_model = '/usr/' + 'lib' + '/xen/bin/qemu-dm'
> device_model = 'qemu-dm'
>
> #-----------------------------------------------------------------------------
> # boot on floppy (a), hard disk (c) or CD-ROM (d)
> # default: hard disk, cd-rom, floppy
> boot="cd"
> sdl=0
> vnc=1
> vnclisten="192.168.1.2"
> vncdisplay=1
> vncunused=1
> vncconsole=0
> vncpasswd=''
>
> #serial='pty'
> #usbdevice='tablet'
> # onboard
> #pci = [ '00:02.0' ]
> ##########################
> # Xen 3.5 unstable options
> ##########################
> # nVidia Geforce 8400 GS & firewire controller & HD audio controller
> #pci = [ '01:00.0','02:01.0','00:1b.0' ]
> #######################
> # Xen 4.0.1-rc6 options
> #######################
> # IGD & HD audio controller
> pci = [ '00:02.0','00:1b.0' ]
>
>
> vcpus=2
> ##########################
> # Xen 3.5 unstable options
> ##########################
> # No passthrough
> #gfx_passthru=0
> # onboard
> #gfx_passthru=1
> # nvidia
> #gfx_passthru=2
> #######################
> # Xen 4.0.1-rc6 options
> #######################
> gfx_passthru=1
>
>
> # Can only pass through one usb device at a time
> usb=1
> # USB Unity Green Mouse
> #usbdevice = 'host:1bcf:0007'
> # USB A1pro Black Mouse
> usbdevice = 'host:15d9:0a41'
> # USB Keyboard
> #usbdevice = 'host:0603:00f2'
> # USB Sony IC Recorder
> #usbdevice = 'host:054c:0271'
> # USB Lexmark X1270 Color Printer
> #usbdevice = 'host:043d:00ff'
> # USB Lexmark X1270 Photo Scanner
> #usbdevice = 'host:043d:007d'
> # USB Lexmark X1270 Generic Hub
> #usbdevice = 'host:043d:007a'
> # Hauppauge WinTV PVR USB2 TV Tuner
> #usbdevice = 'host:2040:2400'
>
> tsc_native=1
>
> At the moment the command "xm create winxphome32" is executed, my LCD 
> monitor immediately goes blank with the label "NO SIGNAL". But, three 
> minutes later, Windows XP Home Edition HVM domU starts booting! It 
> took a good solid 3 minutes for WinXP Home HVM to start booting! Like 
> I mentioned earlier in this email, I was not patient enough. Intel IGD 
> (primary display adapter) VGA passthrough to Windows XP Home Edition 
> HVM domU definitely works with Xen 4.0.1-rc6-pre hypervisor and pv-ops 
> dom0 kernel 2.6.32.19. I can see the Windows XP GUI and all that. But 
> shortly after Windows XP Home Edition HVM domU starts booting, it 
> complains that it couldn't load the SoundMAX audio driver and 
> subsequently crashes with the Blue Screen of Death (BSOD). Dom0 is 
> still running and didn't hang. I could still issue the command to 
> reboot in Domain 0.
>
> Here is my Xen 4.0.1-rc6-pre and pv-ops dom0 kernel 2.6.32.19 kernel 
> debug log.
>
> Section 14: Kernel Debugging Output through the Xen Serial Console
> ===========================================
>
> Shutting down smartd: [  OK  ]
> Stopping boinc-client: [  OK  ]
> Stopping mythbackend: [  OK  ]
> Shutting down console mouse services: [  OK  ]
> Stopping httpd: [  OK  ]
> Stopping ntop: [  OK  ]
> Stopping clamd.scan: [  OK  ]
> Shutting down sm-client: [  OK  ]
> Shutting down sendmail: [  OK  ]
> Stopping MySQL:  [  OK  ]
> Stopping crond: [  OK  ]
> Stopping acpi daemon: [  OK  ]
> Stopping HAL daemon: [  OK  ]
> Stopping lm_sensors: [  OK  ]
> Stopping system message bus: [  OK  ]
> Stopping auditd: [  OK  ]
> Shutting down system logger: [  OK  ]
> Shutting down interface eth0:  snort[3357]: pcap_loop: recvfrom: 
> Network is down
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: Packet Wire Totals:
>
> snort[3357]:    Received:           56
>
> snort[3357]:    Analyzed:           56 (100.000%)
>
> snort[3357]:     Dropped:            0 (0.000%)
>
> snort[3357]: Outstanding:            0 (0.000%)
>
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: Breakdown by protocol (includes rebuilt packets):
>
> snort[3357]:       ETH: 56         (100.000%)
>
> snort[3357]:   ETHdisc: 0          (0.000%)
>
> snort[3357]:      VLAN: 0          (0.000%)
>
> snort[3357]:      IPV6: 0          (0.000%)
>
> snort[3357]:   IP6 EXT: 0          (0.000%)
>
> snort[3357]:   IP6opts: 0          (0.000%)
>
> snort[3357]:   IP6disc: 0          (0.000%)
>
> snort[3357]:       IP4: 54         (96.429%)
>
> snort[3357]:   IP4disc: 0          (0.000%)
>
> snort[3357]:     TCP 6: 0          (0.000%)
>
> snort[3357]:     UDP 6: 0          (0.000%)
>
> snort[3357]:     ICMP6: 0          (0.000%)
>
> snort[3357]:   ICMP-IP: 0          (0.000%)
>
> snort[3357]:       TCP: 40         (71.429%)
>
> snort[3357]:       UDP: 14         (25.000%)
>
> snort[3357]:      ICMP: 0          (0.000%)
>
> snort[3357]:   TCPdisc: 0          (0.000%)
>
> snort[3357]:   UDPdisc: 0          (0.000%)
>
> snort[3357]:   ICMPdis: 0          (0.000%)
>
> snort[3357]:      FRAG: 0          (0.000%)
>
> snort[3357]:    FRAG 6: 0          (0.000%)
>
> snort[3357]:       ARP: 2          (3.571%)
>
> snort[3357]:     EAPOL: 0          (0.000%)
>
> snort[3357]:   ETHLOOP: 0          (0.000%)
>
> snort[3357]:       IPX: 0          (0.000%)
>
> snort[3357]:     OTHER: 0          (0.000%)
>
> snort[3357]:   DISCARD: 0          (0.000%)
>
> snort[3357]: InvChkSum: 10         (17.857%)
>
> snort[3357]:    S5 G 1: 0          (0.000%)
>
> snort[3357]:    S5 G 2: 0          (0.000%)
>
> snort[3357]:     Total: 56
>
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: Action Stats:
>
> snort[3357]: ALERTS: 0
>
> snort[3357]: LOGGED: 0
>
> snort[3357]: PASSED: 0
>
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: Frag3 statistics:
>
> snort[3357]:         Total Fragments: 0
>
> snort[3357]:       Frags Reassembled: 0
>
> snort[3357]:                Discards: 0
>
> snort[3357]:           Memory Faults: 0
>
> snort[3357]:                Timeouts: 0
>
> snort[3357]:                Overlaps: 0
>
> snort[3357]:               Anomalies: 0
>
> snort[3357]:                  Alerts: 0
>
> snort[3357]:      FragTrackers Added: 0
>
> snort[3357]:     FragTrackers Dumped: 0
>
> snort[3357]: FragTrackers Auto Freed: 0
>
> snort[3357]:     Frag Nodes Inserted: 0
>
> snort[3357]:      Frag Nodes Deleted: 0
>
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: Stream5 statistics:
>
> snort[3357]:             Total sessions: 3
>
> snort[3357]:               TCP sessions: 3
>
> snort[3357]:               UDP sessions: 0
>
> snort[3357]:              ICMP sessions: 0
>
> snort[3357]:                 TCP Prunes: 0
>
> snort[3357]:                 UDP Prunes: 0
>
> snort[3357]:                ICMP Prunes: 0
>
> snort[3357]: TCP StreamTrackers Created: 3
>
> snort[3357]: TCP StreamTrackers Deleted: 3
>
> snort[3357]:               TCP Timeouts: 2
>
> snort[3357]:               TCP Overlaps: 0
>
> snort[3357]:        TCP Segments Queued: 0
>
> snort[3357]:      TCP Segments Released: 0
>
> snort[3357]:        TCP Rebuilt Packets: 0
>
> snort[3357]:          TCP Segments Used: 0
>
> snort[3357]:               TCP Discards: 3
>
> snort[3357]:       UDP Sessions Created: 0
>
> snort[3357]:       UDP Sessions Deleted: 0
>
> snort[3357]:               UDP Timeouts: 0
>
> snort[3357]:               UDP Discards: 0
>
> snort[3357]:                     Events: 0
>
> snort[3357]:            TCP Port Filter
>
> snort[3357]:                    Dropped: 0
>
> snort[3357]:                  Inspected: 0
>
> snort[3357]:                    Tracked: 37
>
> snort[3357]:            UDP Port Filter
>
> snort[3357]:                    Dropped: 0
>
> snort[3357]:                  Inspected: 0
>
> snort[3357]:                    Tracked: 0
>
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: HTTP Inspect - encodings (Note: stream-reassembled 
> packets included):
>
> snort[3357]:     POST methods:                   0
>
> snort[3357]:     GET methods:                    0
>
> snort[3357]:     Headers extracted:              0
>
> snort[3357]:     Header Cookies extracted:       0
>
> snort[3357]:     Post parameters extracted:      0
>
> snort[3357]:     Unicode:                        0
>
> snort[3357]:     Double unicode:                 0
>
> snort[3357]:     Non-ASCII representable:        0
>
> snort[3357]:     Base 36:                        0
>
> snort[3357]:     Directory traversals:           0
>
> snort[3357]:     Extra slashes ("//"):           0
>
> snort[3357]:     Self-referencing paths ("./"):  0
>
> snort[3357]:     Total packets processed:        9
>
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: dcerpc2 Preprocessor Statistics
>
> snort[3357]:   Total sessions: 0
>
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: 
> =============================================================================== 
>
>
> snort[3357]: Snort exiting
>
> [  OK  ]
> Shutting down loopback interface:  [  OK  ]
> iptables: Flushing firewall rules: [  OK  ]
> iptables: Setting chains to policy ACCEPT: filter [  OK  ]
> iptables: Unloading modules: [  OK  ]
> Shutting down Barnyard: [  OK  ]
> Shutting down snort service: [FAILED]
> Sending all processes the TERM signal...
> Sending all processes the KILL signal...
> Saving mixer settings
> Saving random seed:
> Syncing hardware clock to system time
> Turning off swap:
> Turning off quotas:
> Unmounting file systems:
> Please stand by while rebooting the system...
> Restarting system.
> (XEN) Domain 0 shutdown: rebooting machine.
> (XEN) Resetting with ACPI MEMORY or I/O RESET_REG.
>  __  __            _  _    ___   _              __
>  \ \/ /___ _ __   | || |  / _ \ / |   _ __ ___ / /_     _ __  _ __ ___
>   \  // _ \ '_ \  | || |_| | | || |__| '__/ __| '_ \ __| '_ \| '__/ _ \
>   /  \  __/ | | | |__   _| |_| || |__| | | (__| (_) |__| |_) | | |  __/
>  /_/\_\___|_| |_|    |_|(_)___(_)_|  |_|  \___|\___/   | .__/|_|  \___|
>                                                        |_|
> (XEN) Xen version 4.0.1-rc6-pre (root@(none)) (gcc version 4.4.1 
> 20090725 (Red Hat 4.4.1-2) (GCC) ) Tue Aug 17 02:18:29 SGT 2010
> (XEN) Latest ChangeSet: Wed Aug 11 16:44:03 2010 +0100 21307:8e8dd38374e9
> (XEN) Console output is synchronous.
> (XEN) Bootloader: GNU GRUB 0.97
> (XEN) Command line: dom0_mem=1024M iommu=1 loglvl=all guest_loglvl=all 
> sync_console console_to_ring com1=115200,8n1 console=com1
> (XEN) Video information:
> (XEN)  VGA is text mode 80x25, font 8x16
> (XEN)  VBE/DDC methods: V2; EDID transfer time: 1 seconds
> (XEN) Disc information:
> (XEN)  Found 2 MBR signatures
> (XEN)  Found 3 EDD information structures
> (XEN) Xen-e820 RAM map:
> (XEN)  0000000000000000 - 000000000009ec00 (usable)
> (XEN)  000000000009ec00 - 00000000000a0000 (reserved)
> (XEN)  00000000000e0000 - 0000000000100000 (reserved)
> (XEN)  0000000000100000 - 000000007d67e000 (usable)
> (XEN)  000000007d67e000 - 000000007d702000 (ACPI NVS)
> (XEN)  000000007d702000 - 000000007d82a000 (reserved)
> (XEN)  000000007d82a000 - 000000007d83e000 (ACPI NVS)
> (XEN)  000000007d83e000 - 000000007d943000 (reserved)
> (XEN)  000000007d943000 - 000000007d94b000 (ACPI data)
> (XEN)  000000007d94b000 - 000000007d966000 (ACPI NVS)
> (XEN)  000000007d966000 - 000000007d988000 (reserved)
> (XEN)  000000007d988000 - 000000007d98e000 (ACPI NVS)
> (XEN)  000000007d98e000 - 000000007db00000 (usable)
> (XEN)  000000007dc00000 - 0000000080000000 (reserved)
> (XEN)  00000000fed1c000 - 00000000fed20000 (reserved)
> (XEN)  00000000ff000000 - 0000000100000000 (reserved)
> (XEN)  0000000100000000 - 00000001fc000000 (usable)
> (XEN) ACPI: RSDP 000F03C0, 0024 (r2  INTEL)
> (XEN) ACPI: XSDT 7D949E18, 005C (r1 INTEL  DQ45CB         5D MSFT    
> 10013)
> (XEN) ACPI: FACP 7D948D98, 00F4 (r4  INTEL    A M I  6222004 MSFT    
> 10013)
> (XEN) ACPI: DSDT 7D943018, 4B53 (r1 INTEL  DQ45CB         5D INTL 
> 20051117)
> (XEN) ACPI: FACS 7D951F40, 0040
> (XEN) ACPI: APIC 7D948F18, 006C (r2 INTEL  DQ45CB         5D MSFT    
> 10013)
> (XEN) ACPI: MCFG 7D953E18, 003C (r1 INTEL  DQ45CB         5D 
> MSFT       97)
> (XEN) ACPI: ASF! 7D952D18, 00A0 (r32 INTEL  DQ45CB         5D TFSM    
> F4240)
> (XEN) ACPI: SPCR 7D953D98, 0050 (r1 INTEL  DQ45CB         5D 
> AMI.        3)
> (XEN) ACPI: TCPA 7D953D18, 0032 (r2 INTEL  DQ45CB         5D MSFT  
> 1000013)
> (XEN) ACPI: DMAR 7D701D98, 0110 (r1 INTEL  DQ45CB         5D 
> INTL        1)
> (XEN) System RAM: 6039MB (6184504kB)
> (XEN) No NUMA configuration found
> (XEN) Faking a node at 0000000000000000-00000001fc000000
> (XEN) Domain heap initialised
> (XEN) DMI 2.4 present.
> (XEN) Using APIC driver default
> (XEN) ACPI: PM-Timer IO Port: 0x408
> (XEN) ACPI: ACPI SLEEP INFO: pm1x_cnt[404,0], pm1x_evt[400,0]
> (XEN) ACPI: 32/64X FACS address mismatch in FADT - 
> 7d94cf40/000000007d951f40, using 32
> (XEN) ACPI:                  wakeup_vec[7d94cf4c], vec_size[20]
> (XEN) ACPI: Local APIC address 0xfee00000
> (XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> (XEN) Processor #0 7:7 APIC version 20
> (XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> (XEN) Processor #1 7:7 APIC version 20
> (XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
> (XEN) ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
> (XEN) ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> (XEN) IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
> (XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> (XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> (XEN) ACPI: IRQ0 used by override.
> (XEN) ACPI: IRQ2 used by override.
> (XEN) ACPI: IRQ9 used by override.
> (XEN) Enabling APIC mode:  Flat.  Using 1 I/O APICs
> (XEN) PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> (XEN) PCI: Not using MMCONFIG.
> (XEN) Using ACPI (MADT) for SMP configuration information
> (XEN) Using scheduler: SMP Credit Scheduler (credit)
> (XEN) Detected 2800.167 MHz processor.
> (XEN) Initing memory sharing.
> (XEN) VMX: Supported advanced features:
> (XEN)  - APIC MMIO access virtualisation
> (XEN)  - APIC TPR shadow
> (XEN)  - Virtual NMI
> (XEN)  - MSR direct-access bitmap
> (XEN) HVM: ASIDs disabled.
> (XEN) HVM: VMX enabled
> (XEN) xsave_init: cpu0: cntxt_max_size: 0x240 and states: 
> 00000000:00000003
> (XEN) xsave_init: using cntxt_size: 0x240 and states: 00000000:00000003
> (XEN) Intel machine check reporting enabled
> (XEN) Intel VT-d Snoop Control not supported.
> (XEN) Intel VT-d DMA Passthrough not supported.
> (XEN) Intel VT-d Queued Invalidation not supported.
> (XEN) Intel VT-d Interrupt Remapping not supported.
> (XEN) I/O virtualisation enabled
> (XEN)  - Dom0 mode: Relaxed
> (XEN) xsave_init: cpu1: cntxt_max_size: 0x240 and states: 
> 00000000:00000003
> (XEN) Total of 2 processors activated.
> (XEN) ENABLING IO-APIC IRQs
> (XEN)  -> Using new ACK method
> (XEN) ..TIMER: vector=0xF0 apic1=0 pin1=2 apic2=-1 pin2=-1
> (XEN) checking TSC synchronization across 2 CPUs: passed.
> (XEN) Platform timer appears to have unexpectedly wrapped 10 or more 
> times.
> (XEN) Platform timer is 3.579MHz ACPI PM Timer
> ÿ(XEN) Allocated console ring of 16 KiB.
> (XEN) Brought up 2 CPUs
> (XEN) microcode.c:73:d32767 microcode: CPU1 resumed
> (XEN) CPUIDLE: disabled due to no HPET. Force enable with 'cpuidle'.
> (XEN) ACPI sleep modes: S3
> (XEN) mcheck_poll: Machine check polling timer started.
> (XEN) *** LOADING DOMAIN 0 ***
> (XEN)  Xen  kernel: 64-bit, lsb, compat32
> (XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x18d0000
> (XEN) PHYSICAL MEMORY ARRANGEMENT:
> (XEN)  Dom0 alloc.:   00000001f0000000->00000001f4000000 (245760 pages 
> to be allocated)
> (XEN) VIRTUAL MEMORY ARRANGEMENT:
> (XEN)  Loaded kernel: ffffffff81000000->ffffffff818d0000
> (XEN)  Init. ramdisk: ffffffff818d0000->ffffffff82043c00
> (XEN)  Phys-Mach map: ffffffff82044000->ffffffff82244000
> (XEN)  Start info:    ffffffff82244000->ffffffff822444b4
> (XEN)  Page tables:   ffffffff82245000->ffffffff8225a000
> (XEN)  Boot stack:    ffffffff8225a000->ffffffff8225b000
> (XEN)  TOTAL:         ffffffff80000000->ffffffff82400000
> (XEN)  ENTRY ADDRESS: ffffffff8166a200
> (XEN) Dom0 has maximum 2 VCPUs
> (XEN) Scrubbing Free RAM: 
> .................................................done.
> (XEN) trace.c:89:d32767 calc_tinfo_first_offset: NR_CPUs 128, 
> offset_in_bytes 258, t_info_first_offset 65
> (XEN) Xen trace buffers: disabled
> (XEN) Std. Loglevel: All
> (XEN) Guest Loglevel: All
> (XEN) **********************************************
> (XEN) ******* WARNING: CONSOLE OUTPUT IS SYNCHRONOUS
> (XEN) ******* This option is intended to aid debugging of Xen by ensuring
> (XEN) ******* that all output is synchronously delivered on the serial 
> line.
> (XEN) ******* However it can introduce SIGNIFICANT latencies and affect
> (XEN) ******* timekeeping. It is NOT recommended for production use!
> (XEN) **********************************************
> (XEN) 3... 2... 1...
> (XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch 
> input to Xen)
> (XEN) Freed 172kB init memory.
> mapping kernel into physical memory
> Xen: setup ISA identity maps
> about to get started...
> ERROR: Unable to locate IOAPIC for GSI 2
> ERROR: Unable to locate IOAPIC for GSI 9
> ERROR: Unable to locate IOAPIC for GSI 9
> (XEN) PCI add device 00:00.0
> (XEN) PCI add device 00:01.0
> (XEN) PCI add device 00:02.0
> (XEN) PCI add device 00:03.0
> (XEN) PCI add device 00:03.2
> (XEN) PCI add device 00:03.3
> (XEN) PCI add device 00:19.0
> (XEN) PCI add device 00:1a.0
> (XEN) PCI add device 00:1a.1
> (XEN) PCI add device 00:1a.2
> (XEN) PCI add device 00:1a.7
> (XEN) PCI add device 00:1b.0
> (XEN) PCI add device 00:1d.0
> (XEN) PCI add device 00:1d.1
> (XEN) PCI add device 00:1d.2
> (XEN) PCI add device 00:1d.7
> (XEN) PCI add device 00:1e.0
> (XEN) PCI add device 00:1f.0
> (XEN) PCI add device 00:1f.2
> (XEN) PCI add device 00:1f.3
> (XEN) PCI add device 00:1f.5
> (XEN) PCI add device 01:00.0
> (XEN) PCI add device 02:01.0
> registering netback
> %G        Welcome to Fedora
>         Press 'I' to enter interactive startup.
> Starting udev: %G[  OK  ]
> Setting hostname fedora11-x86-64-host:  [  OK  ]
> mdadm: No arrays found in config file or automatically
> Setting up Logical Volume Management:   20 logical volume(s) in volume 
> group "virtualmachines" now active
>   4 logical volume(s) in volume group "vg_fedora11_host" now active
> [  OK  ]
> Checking filesystems
> Checking all file systems.
> [/sbin/fsck.ext4 (1) -- /] fsck.ext4 -a 
> /dev/mapper/vg_fedora11_host-lv_root
> /dev/mapper/vg_fedora11_host-lv_root: clean, 497285/1966080 files, 
> 5044536/7864320 blocks
> [/sbin/fsck.ext3 (1) -- /boot] fsck.ext3 -a /dev/sda1
> /dev/sda1: clean, 80/51200 files, 128389/204800 blocks
> [/sbin/fsck.ext4 (1) -- /var] fsck.ext4 -a 
> /dev/mapper/vg_fedora11_host-lv_var
> /dev/mapper/vg_fedora11_host-lv_var: clean, 31793/655360 files, 
> 501177/2621440 blocks
> [/sbin/fsck.ext4 (1) -- /home] fsck.ext4 -a 
> /dev/mapper/vg_fedora11_host-lv_home
> /dev/mapper/vg_fedora11_host-lv_home: clean, 27796/655360 files, 
> 2238819/2621440 blocks
> [  OK  ]
> Remounting root filesystem in read-write mode:  [  OK  ]
> Mounting local filesystems:  [  OK  ]
> Enabling local filesystem quotas:  [  OK  ]
> Enabling /etc/fstab swaps:  [  OK  ]
> Entering non-interactive startup
> Applying Intel CPU microcode update: WARNING: All config files need 
> .conf: /etc/modprobe.d/blacklist.conf-intel, it will be ignored in a 
> future release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-original, it will be ignored in a 
> future release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-nvidia, it will be ignored in a future 
> release.
> [  OK  ]
> iptables: Applying firewall rules: [  OK  ]
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-intel, it will be ignored in a future 
> release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-original, it will be ignored in a 
> future release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-nvidia, it will be ignored in a future 
> release.
> Bringing up loopback interface:  [  OK  ]
> Bringing up interface eth0:
> Determining IP information for eth0... done.
> [  OK  ]
> Bringing up interface vpn_000:  WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-intel, it will be ignored in a future 
> release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-original, it will be ignored in a 
> future release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-nvidia, it will be ignored in a future 
> release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-intel, it will be ignored in a future 
> release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-original, it will be ignored in a 
> future release.
> WARNING: All config files need .conf: 
> /etc/modprobe.d/blacklist.conf-nvidia, it will be ignored in a future 
> release.
> Device vpn_000 does not seem to be present, delaying initialization.
> [FAILED]
> Starting auditd: [  OK  ]
> Starting system logger: [  OK  ]
> Starting irqbalance: [  OK  ]
> Starting system message bus: [  OK  ]
> Starting acpi daemon: [  OK  ]
> Starting HAL daemon: [  OK  ]
> Starting lm_sensors: loading module coretemp [  OK  ]
> Starting MySQL:  [  OK  ]
> Starting clamd.scan: LibClamAV Warning: 
> **************************************************
> LibClamAV Warning: ***  The virus database is older than 7 days!  ***
> LibClamAV Warning: ***   Please update it as soon as possible.    ***
> LibClamAV Warning: **************************************************
> LibClamAV Warning: 
> ***********************************************************
> LibClamAV Warning: ***  This version of the ClamAV engine is 
> outdated.     ***
> LibClamAV Warning: *** DON'T PANIC! Read 
> http://www.clamav.net/support/faq ***
> LibClamAV Warning: 
> ***********************************************************
> [  OK  ]
> Starting sendmail: [  OK  ]
> Starting sm-client: [  OK  ]
> Starting ntop: [  OK  ]
> Error Opening file ./GeoLiteCity.dat
> Starting console mouse services: Error Opening file ./GeoIPASNum.dat
> [  OK  ]
> Starting httpd: httpd: apr_sockaddr_info_get() failed for 
> fedora11-x86-64-host
> httpd: Could not reliably determine the server's fully qualified 
> domain name, using 127.0.0.1 for ServerName
> [  OK  ]
> Starting mythbackend: [  OK  ]
> Starting crond: [  OK  ] [  OK  ]
> Starting boinc-client: [  OK  ]
> Starting Barnyard: Barnyard Version 0.2.0 (Build 32)
>  3199
> [  OK  ]
> Starting OSSEC: 2010/08/18 11:51:49 ossec-maild: INFO: E-Mail 
> notification disabled. Clean Exit.
> [  OK  ]
> Starting smartd: [  OK  ]
> Starting snort service:  3392
> [  OK  ]
>
> Fedora release 11 (Leonidas)
> Kernel 2.6.32.19-xen-enming.teo on an x86_64 (/dev/hvc0)
>
> ================================================================================ 
>
> Banner Created on 5th September 2009 A.D. Saturday at 10:57 A.M. SGT
>
> This is the home personal computer system of
>
> Mr. Teo En Ming Dip(Mechatronics) BEng(Hons)(Mechanical Engineering)
> Alma Maters:
> (1) Singapore Polytechnic
> (2) National University of Singapore
> Hanyu Pinyin Name: Zhang Enming
> Age: 31
> Email: space.time.universe@gmail.com
> Mobile Phone: +65-9648-9798
> Street: Bedok Reservoir Road
> Republic of Singapore
> ================================================================================ 
>
>
> fedora11-x86-64-host login:
> Fedora release 11 (Leonidas)
> Kernel 2.6.32.19-xen-enming.teo on an x86_64 (/dev/hvc0)
>
> ================================================================================ 
>
> Banner Created on 5th September 2009 A.D. Saturday at 10:57 A.M. SGT
>
> This is the home personal computer system of
>
> Mr. Teo En Ming Dip(Mechatronics) BEng(Hons)(Mechanical Engineering)
> Alma Maters:
> (1) Singapore Polytechnic
> (2) National University of Singapore
> Hanyu Pinyin Name: Zhang Enming
> Age: 31
> Email: space.time.universe@gmail.com
> Mobile Phone: +65-9648-9798
> Street: Bedok Reservoir Road
> Republic of Singapore
> ================================================================================ 
>
>
> fedora11-x86-64-host login:
> Fedora release 11 (Leonidas)
> Kernel 2.6.32.19-xen-enming.teo on an x86_64 (/dev/hvc0)
>
> ================================================================================ 
>
> Banner Created on 5th September 2009 A.D. Saturday at 10:57 A.M. SGT
>
> This is the home personal computer system of
>
> Mr. Teo En Ming Dip(Mechatronics) BEng(Hons)(Mechanical Engineering)
> Alma Maters:
> (1) Singapore Polytechnic
> (2) National University of Singapore
> Hanyu Pinyin Name: Zhang Enming
> Age: 31
> Email: space.time.universe@gmail.com
> Mobile Phone: +65-9648-9798
> Street: Bedok Reservoir Road
> Republic of Singapore
> ================================================================================ 
>
>
> fedora11-x86-64-host login: root
> Password:
> Last login: Wed Aug 18 11:48:49 on tty1
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]# start-windows
> + service boinc-client stop
> Stopping boinc-client:
>
>
>
>
> [  OK  ]
> + service snort stop
> Shutting down snort service: [  OK  ]
> + service barnyard stop
> Shutting down Barnyard: [  OK  ]
> + service ntop stop
> Stopping ntop: [  OK  ]
> + service ossec stop
> Stopping OSSEC: [  OK  ]
> + /etc/xen/scripts/passthru-igd.sh
> + echo '8086 2e12'
> + echo 0000:00:02.0
> + echo 0000:00:02.0
> + /etc/xen/scripts/passthru-firewire.sh
> + echo '11c1 5811'
> + echo 0000:02:01.0
> + echo 0000:02:01.0
> + rmmod firewire_ohci
> + rmmod firewire_core
> + /etc/xen/scripts/passthru-audio.sh
> + echo '8086 3a6e'
> + echo 0000:00:1b.0
> + echo 0000:00:1b.0
> + rmmod snd_hda_intel
> + ls -ltr /sys/bus/pci/drivers/pci-stub/
> total 0
> --w------- 1 root root 4096 2010-08-18 11:54 unbind
> --w------- 1 root root 4096 2010-08-18 11:54 new_id
> --w------- 1 root root 4096 2010-08-18 11:54 bind
> --w------- 1 root root 4096 2010-08-18 11:54 uevent
> --w------- 1 root root 4096 2010-08-18 11:54 remove_id
> lrwxrwxrwx 1 root root    0 2010-08-18 11:54 0000:02:01.0 -> 
> ../../../../devices/pci0000:00/0000:00:1e.0/0000:02:01.0
> lrwxrwxrwx 1 root root    0 2010-08-18 11:54 0000:00:1b.0 -> 
> ../../../../devices/pci0000:00/0000:00:1b.0
> lrwxrwxrwx 1 root root    0 2010-08-18 11:54 0000:00:02.0 -> 
> ../../../../devices/pci0000:00/0000:00:02.0
> + sleep 5
> + xm create winxphome32
> Using config file "/etc/xen/winxphome32".
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
> (XEN) domctl.c:1035:d0 ioport_map:add f_gport=3b0 f_mport=3b0 np=c
> (XEN) domctl.c:1035:d0 ioport_map:add f_gport=3c0 f_mport=3c0 np=20
> (XEN) domctl.c:979:d0 memory_map:add: gfn=a0 mfn=a0 nr_mfns=20
>
> (XEN) HVM1: HVM Loader
> Started domain winxphome32 (id=1)(XEN) HVM1: Detected Xen v4.0.1-rc6-pre
>
> (XEN) HVM1: CPU speed is 2800 MHz
> (XEN) irq.c:243: Dom1 PCI link 0 changed 0 -> 5
> (XEN) HVM1: PCI-ISA link 0 routed to IRQ5
> (XEN) irq.c:243: Dom1 PCI link 1 changed 0 -> 10
> (XEN) HVM1: PCI-ISA link 1 routed to IRQ10
> (XEN) irq.c:243: Dom1 PCI link 2 changed 0 -> 11
> (XEN) HVM1: PCI-ISA link 2 routed to IRQ11
> (XEN) irq.c:243: Dom1 PCI link 3 changed 0 -> 5
> (XEN) HVM1: PCI-ISA link 3 routed to IRQ5
> (XEN) HVM1: pci dev 01:2 INTD->IRQ5
> You have new mail in /var/spool/mail/root
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> (XEN) HVM1: pci dev 01:3 INTA->IRQ10
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> (XEN) HVM1: pci dev 02:0 INTA->IRQ11
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]# (XEN) HVM1: pci dev 03:0 INTA->IRQ5
> (XEN) HVM1: pci dev 04:0 INTA->IRQ5
> (XEN) HVM1: pci dev 05:0 INTA->IRQ10
> (XEN) domctl.c:979:d0 memory_map:add: gfn=e0000 mfn=b0000 nr_mfns=10000
> (XEN) HVM1: pci dev 02:0 bar 18 size 10000000: e000000c
> (XEN) HVM1: pci dev 03:0 bar 14 size 01000000: f0000008
> (XEN) domctl.c:979:d0 memory_map:add: gfn=f1000 mfn=d3400 nr_mfns=400
> (XEN) HVM1: pci dev 02:0 bar 10 size 00400000: f1000004
> (XEN) domctl.c:979:d0 memory_map:add: gfn=f1400 mfn=d3920 nr_mfns=4
> (XEN) HVM1: pci dev 05:0 bar 10 size 00004000: f1400004
> (XEN) HVM1: pci dev 03:0 bar 10 size 00000100: 0000c001
> (XEN) HVM1: pci dev 04:0 bar 10 size 00000100: 0000c101
> (XEN) HVM1: pci dev 04:0 bar 14 size 00000100: f1404000
> (XEN) HVM1: pci dev 01:2 bar 20 size 00000020: 0000c201
> (XEN) HVM1: pci dev 01:1 bar 20 size 00000010: 0000c221
> (XEN) domctl.c:1035:d0 ioport_map:add f_gport=c230 f_mport=e220 np=8
> (XEN) HVM1: pci dev 02:0 bar 20 size 00000008: 0000c231
> (XEN) HVM1: Multiprocessor initialisation:
> (XEN) HVM1:  - CPU0 ... 36-bit phys ... fixed MTRRs ... var MTRRs 
> [3/8] ... done.
> (XEN) HVM1:  - CPU1 ... 36-bit phys ... fixed MTRRs ... var MTRRs 
> [3/8] ... done.
> (XEN) HVM1: Writing SMBIOS tables ...
> (XEN) HVM1: Loading ROMBIOS ...
> (XEN) HVM1: 10524 bytes of ROMBIOS high-memory extensions:
> (XEN) HVM1:   Relocating to 0xfc000000-0xfc00291c ... done
> (XEN) HVM1: Creating MP tables ...
> (XEN) HVM1: Loading VGABIOS of passthroughed gfx ...
> (XEN) HVM1: Loading PCI Option ROM ...
> (XEN) HVM1:  - Manufacturer: http://etherboot.org
> (XEN) HVM1:  - Product name: gPXE
> (XEN) HVM1: Loading ACPI ...
> (XEN) HVM1:  - Lo data: 000ea020-000ea04f
> (XEN) HVM1:  - Hi data: fc002c00-fc012d1f
> (XEN) HVM1: vm86 TSS at fc013000
> (XEN) HVM1: BIOS map:
> (XEN) HVM1:  c0000-cc7ff: VGA BIOS
> (XEN) HVM1:  cc800-d8fff: Etherboot ROM
> (XEN) HVM1:  eb000-eb177: SMBIOS tables
> (XEN) HVM1:  f0000-fffff: Main BIOS
> (XEN) HVM1: Invoking ROMBIOS ...
> (XEN) HVM1: $Revision: 1.221 $ $Date: 2008/12/07 17:32:29 $
> (XEN) HVM1: *** int 15h function AX=5f21, BX=c000 not yet supported!
> (XEN) HVM1: *** int 15h function AX=5f22, BX=0004 not yet supported!
> (XEN) HVM1: Bochs BIOS - build: 06/23/99
> (XEN) HVM1: $Revision: 1.221 $ $Date: 2008/12/07 17:32:29 $
> (XEN) HVM1: Options: apmbios pcibios eltorito PMM
> (XEN) HVM1:
> (XEN) HVM1: ata0-0: PCHS=16383/16/63 translation=lba LCHS=1024/255/63
> (XEN) HVM1: ata0 master: QEMU HARDDISK ATA-7 Hard-Disk (51200 MBytes)
> (XEN) HVM1: IDE time out
> (XEN) HVM1: ata1 master: QEMU DVD-ROM ATAPI-4 CD-Rom/DVD-Rom
> (XEN) HVM1: IDE time out
> (XEN) HVM1:
> (XEN) HVM1: PCI BIOS: PCI not present
> (XEN) HVM1:
> (XEN) HVM1:
> (XEN) HVM1: Press F12 for boot menu.
> (XEN) HVM1:
> (XEN) HVM1: Booting from Hard Disk...
> (XEN) HVM1: Booting from 0000:7c00
> (XEN) HVM1: PCI BIOS: PCI not present
> (XEN) HVM1: int13_harddisk: function 15, unmapped device for ELDL=81
> (XEN) HVM1: *** int 15h function AX=e980, BX=0069 not yet supported!
> (XEN) irq.c:243: Dom1 PCI link 0 changed 5 -> 0
> (XEN) irq.c:243: Dom1 PCI link 1 changed 10 -> 0
> (XEN) irq.c:243: Dom1 PCI link 2 changed 11 -> 0
> (XEN) irq.c:243: Dom1 PCI link 3 changed 5 -> 0
> (XEN) domctl.c:989:d0 memory_map:remove: gfn=f1000 mfn=d3400 nr_mfns=400
> (XEN) domctl.c:989:d0 memory_map:remove: gfn=e0000 mfn=b0000 
> nr_mfns=10000
> (XEN) domctl.c:1059:d0 ioport_map:remove f_gport=c230 f_mport=e220 np=8
> (XEN) domctl.c:979:d0 memory_map:add: gfn=f1000 mfn=d3400 nr_mfns=400
> (XEN) domctl.c:979:d0 memory_map:add: gfn=e0000 mfn=b0000 nr_mfns=10000
> (XEN) domctl.c:1035:d0 ioport_map:add f_gport=c230 f_mport=e220 np=8
> (XEN) domctl.c:989:d0 memory_map:remove: gfn=f1400 mfn=d3920 nr_mfns=4
> (XEN) domctl.c:979:d0 memory_map:add: gfn=f1400 mfn=d3920 nr_mfns=4
> (XEN) grant_table.c:1121:d1 Expanding dom (1) grant table from (4) to 
> (32) frames.
> (XEN) irq.c:309: Dom1 callback via changed to GSI 28
> (XEN) domctl.c:989:d0 memory_map:remove: gfn=f1400 mfn=d3920 nr_mfns=4
> (XEN) domctl.c:979:d0 memory_map:add: gfn=f1400 mfn=d3920 nr_mfns=4
> (XEN) domctl.c:811:d0 XEN_DOMCTL_test_assign_device: 0:2.0 already 
> assigned, or non-existent
>
> You have new mail in /var/spool/mail/root
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> You have new mail in /var/spool/mail/root
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
> [root@fedora11-x86-64-host ~]#
>
>
>
> The above kernel debugging output is also attached as a text file in 
> this email.
>
> Any ideas why my Windows XP Home Edition HVM domU with Intel IGD VGA 
> passthrough crashed with a BSOD?
>
> Yours sincerely,
>
> Mr. Teo En Ming (Zhang Enming)
> Citizenship: Singapore Citizen/Singaporean
> Facebook account: Teo En Ming (Zhang Enming)
> Facebook link:http://www.facebook.com/profile.php?id=100000750083982
> Facebook photos:
> http://www.facebook.com/profile.php?id=100000750083982#!/profile.php?id=100000750083982&v=photos  <http://www.facebook.com/profile.php?id=100000750083982#%21/profile.php?id=100000750083982&v=photos>
> Facebook videos:
> http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137  <http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137>
> Mobile Phone (Starhub pre-paid): +65-8369-2618
> Windows Live Messenger:teoenming at hotmail.com  <https://admin.fedoraproject.org/mailman/listinfo/users>
> Location: Bedok Reservoir Road, Singapore
> ZIP: 470103
> My Open Letter (Plea for Medical Help/Assistance) to World Leaders:-
> http://lists.mcs.anl.gov/pipermail/mpich-discuss/2010-August/007693.html
> http://lists.fedoraproject.org/pipermail/users/2010-August/380213.html
> http://mythtv.org/pipermail/mythtv-users/2010-August/294733.html
>
>
>
>
>
>
>
> On 08/17/2010 01:57 PM, Pasi Kärkkäinen wrote:
>> On Tue, Aug 17, 2010 at 07:28:08AM +0800, Mr. Teo En Ming (Zhang Enming) of Singapore wrote:
>>    
>>>     Dear All,
>>>
>>>     I have just finished configuring, building/compiling, and installing Xen
>>>     4.0.1-rc6-pre hypervisor and pv-ops dom0 kernel 2.6.32.19 in my Fedora 11
>>>     x86_64 Linux system.
>>>
>>>     I can boot up the Xen 4.0.1-rc6-pre hypervisor and paravirt-ops dom0
>>>     kernel 2.6.32.19 combination successfully to a text console, load the
>>>     driver for the Intel IGD, start the X Windowing Server (startx), and go
>>>     into GNOME Desktop Environment. Networking is working fine and I am able
>>>     to surf the web with my internet connection. Inside the GNOME Graphical
>>>     User Interface (GUI), I am able to start Windows XP Home Edition HVM domU
>>>     guest operating system without VGA passthrough successfully, albeit it is
>>>     very very slow.
>>>
>>>     Then I rebooted to try VGA passthrough of the Intel IGD to Windows XP Home
>>>     Edition HVM domU. It doesn't seem to work. At the moment I execute the
>>>     command "xm create winxphome32", my LCD monitor immediately goes blank
>>>     with the "NO SIGNAL" label. And it stays there. So, in conclusion, I can't
>>>     passthrough the IGD on my Intel Desktop Board DQ45CB with Xen
>>>     4.0.1-rc6-pre and pv-ops dom0 kernel 2.6.32.19 yet.
>>>
>>>     In the following sections, I am providing a lot of technical details to
>>>     allow you guys to help me troubleshoot the problem. Basically, I went
>>>     through the night without sleeping at all. It's 7:16 A.M. Singapore Time
>>>     now and I haven't sleep yet. I will probably try to troubleshoot with a
>>>     serial console later.
>>>
>>>      
>> Yeah, you need a serial console to troubleshoot it..
>>
>> -- Pasi
>>
>>
>>    
>

