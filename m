Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0GaTHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:07:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34686 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0GaTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p6ElFIKdhzoR/YXDaYInP5fV7QzV1ryXNe+IXVHvvmCqqLbwnLuwBEZ++n9ZHfr+ha
         tjrKDm2WfdjjiVPWXYLmmAJ7JGz1VquFdTOEwdouFTe8Syvk1yDd2KPQsOs5pyvocOT8
         RbVEShE4ljPDvZBDT+RUMVAKyR5DZs4geduKM=
Message-ID: <4C547464.6000505@gmail.com>
Date: Sat, 31 Jul 2010 12:07:16 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH]Documentation update broken web addresses.
References: <1279943484-31069-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1279943484-31069-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any ideas on the status of this?

> Below you will find an updated version from the original series bunching all patches into one big patch
> updating broken web addresses that are located in Documentation/*
> Some of the addresses date as far far back as 1995 etc... so searching became a bit difficult,
> the best way to deal with these is to use web.archive.org to locate these addresses that are outdated.
> Now there are also some addresses pointing to .spec files some are located, but some(after searching
> on the companies site)where still no where to be found. In this case I just changed the address
> to the company site this way the users can contact the company and they can locate them for the users.
>
> As for the patch itself if anybody see's anything that might be fixed let me know and I'll fix it up
> and resend. As for the responses for the first series Thank for all the replies with fixes..
> "it's nice to see working web links.."
>
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> Signed-off-by: Thomas Weber<weber@corscience.de>
> Signed-off-by: Mike Frysinger<vapier.adi@gmail.com>
> Cc: Paulo Marques<pmarques@grupopie.com>
> Cc: Randy Dunlap<rdunlap@xenotime.net>
> Cc: Michael Neuling<mikey@neuling.org>
>
> ---
>   Documentation/ABI/testing/sysfs-devices-memory     |    6 +-
>   Documentation/ABI/testing/sysfs-devices-system-cpu |    2 +-
>   Documentation/DocBook/scsi.tmpl                    |    2 +-
>   Documentation/DocBook/v4l/compat.xml               |    5 +-
>   Documentation/DocBook/v4l/fdl-appendix.xml         |    2 +-
>   Documentation/HOWTO                                |    6 +-
>   Documentation/RCU/RTFP.txt                         |    2 +-
>   Documentation/SubmittingDrivers                    |    2 +-
>   Documentation/aoe/aoe.txt                          |    2 +-
>   Documentation/arm/IXP2000                          |    2 +-
>   Documentation/arm/IXP4xx                           |   14 ++--
>   Documentation/arm/README                           |    4 +-
>   Documentation/arm/SA1100/Assabet                   |    5 +-
>   Documentation/arm/SA1100/Brutus                    |    2 +-
>   Documentation/arm/SA1100/FreeBird                  |    2 +-
>   Documentation/arm/SA1100/GraphicsClient            |    2 +-
>   Documentation/arm/SA1100/GraphicsMaster            |    2 +-
>   Documentation/arm/SA1100/Itsy                      |    2 +-
>   Documentation/arm/SA1100/PLEB                      |    2 +-
>   Documentation/arm/SA1100/Victor                    |    2 +-
>   Documentation/arm/SA1100/nanoEngine                |    2 +-
>   Documentation/binfmt_misc.txt                      |    2 +-
>   Documentation/blockdev/paride.txt                  |    2 +-
>   Documentation/cdrom/packet-writing.txt             |    2 +-
>   Documentation/cgroups/cpusets.txt                  |    2 +-
>   Documentation/development-process/4.Coding         |    2 +-
>   Documentation/device-mapper/dm-crypt.txt           |    2 +-
>   Documentation/devices.txt                          |    9 +-
>   Documentation/dvb/faq.txt                          |    2 +-
>   Documentation/fb/framebuffer.txt                   |    2 +-
>   Documentation/filesystems/9p.txt                   |    2 +-
>   Documentation/filesystems/affs.txt                 |    2 +-
>   Documentation/filesystems/befs.txt                 |    4 +-
>   Documentation/filesystems/isofs.txt                |    2 +-
>   Documentation/filesystems/proc.txt                 |    4 +-
>   Documentation/filesystems/vfat.txt                 |    3 +-
>   Documentation/hwmon/adm1026                        |    2 +-
>   Documentation/hwmon/g760a                          |    2 +-
>   Documentation/hwmon/gl518sm                        |    3 +-
>   Documentation/hwmon/k8temp                         |    2 +-
>   Documentation/hwmon/lm85                           |    6 +-
>   Documentation/hwmon/smsc47m1                       |   11 +--
>   Documentation/hwmon/thmc50                         |    2 +-
>   Documentation/hwmon/via686a                        |    2 +-
>   Documentation/hwmon/w83627hf                       |    6 +-
>   Documentation/hwmon/w83781d                        |    2 +-
>   Documentation/hwmon/w83792d                        |    2 +-
>   Documentation/i2c/busses/i2c-ali1535               |    2 +-
>   Documentation/i2c/busses/i2c-ali1563               |    2 +-
>   Documentation/i2c/busses/i2c-ali15x3               |    2 +-
>   Documentation/i2c/busses/i2c-piix4                 |    2 +-
>   Documentation/i2c/busses/i2c-sis630                |    2 +-
>   Documentation/ia64/aliasing.txt                    |    2 -
>   Documentation/ia64/serial.txt                      |    2 +-
>   Documentation/infiniband/user_verbs.txt            |    2 +-
>   Documentation/input/appletouch.txt                 |    2 +-
>   Documentation/input/bcm5974.txt                    |    2 +-
>   Documentation/input/iforce-protocol.txt            |    2 +-
>   Documentation/input/sentelic.txt                   |    2 +-
>   Documentation/input/xpad.txt                       |    2 +-
>   Documentation/intel_txt.txt                        |   12 +--
>   Documentation/ioctl/ioctl-number.txt               |   10 +-
>   Documentation/isdn/README                          |    2 +-
>   Documentation/isdn/README.HiSax                    |    2 +-
>   Documentation/ja_JP/HOWTO                          |    4 +-
>   Documentation/ja_JP/SubmittingPatches              |    6 +-
>   Documentation/kernel-docs.txt                      |   39 ++++-----
>   Documentation/ko_KR/HOWTO                          |    8 +-
>   Documentation/laptops/acer-wmi.txt                 |    2 +-
>   Documentation/ldm.txt                              |    2 +-
>   Documentation/md.txt                               |    2 +-
>   Documentation/misc-devices/c2port.txt              |    4 +-
>   Documentation/mtd/nand_ecc.txt                     |    2 +-
>   Documentation/networking/3c509.txt                 |    2 +-
>   Documentation/networking/README.ipw2100            |    3 +-
>   Documentation/networking/README.ipw2200            |    2 +-
>   Documentation/networking/README.sb1000             |    4 +-
>   Documentation/networking/arcnet.txt                |    4 +-
>   Documentation/networking/bonding.txt               |    2 +-
>   Documentation/networking/decnet.txt                |    2 +-
>   Documentation/networking/fore200e.txt              |    2 +-
>   Documentation/networking/ipddp.txt                 |    5 -
>   Documentation/networking/iphase.txt                |    2 +-
>   Documentation/networking/packet_mmap.txt           |    4 +-
>   Documentation/networking/ray_cs.txt                |    4 +-
>   Documentation/networking/s2io.txt                  |    3 +-
>   Documentation/networking/tlan.txt                  |    4 +-
>   Documentation/networking/udplite.txt               |   13 +--
>   Documentation/networking/wavelan.txt               |    3 +-
>   Documentation/power/apm-acpi.txt                   |    2 +-
>   Documentation/power/basic-pm-debugging.txt         |    3 +-
>   Documentation/power/video.txt                      |   12 ++--
>   Documentation/powerpc/booting-without-of.txt       |    2 +-
>   Documentation/s390/Debugging390.txt                |    2 +-
>   Documentation/scsi/BusLogic.txt                    |    2 +-
>   Documentation/scsi/ChangeLog.megaraid              |    2 +-
>   Documentation/scsi/FlashPoint.txt                  |    4 +-
>   Documentation/scsi/Mylex.txt                       |    2 +-
>   Documentation/scsi/NinjaSCSI.txt                   |    2 -
>   Documentation/scsi/aic79xx.txt                     |    2 +-
>   Documentation/scsi/aic7xxx.txt                     |    2 +-
>   Documentation/scsi/ibmmca.txt                      |    2 +-
>   Documentation/scsi/osst.txt                        |    2 +-
>   Documentation/scsi/ppa.txt                         |    6 +-
>   Documentation/scsi/scsi-generic.txt                |    8 +-
>   Documentation/scsi/scsi.txt                        |    4 +-
>   Documentation/scsi/scsi_mid_low_api.txt            |    2 +-
>   Documentation/serial/moxa-smartio                  |    2 +-
>   Documentation/sound/alsa/ALSA-Configuration.txt    |    2 +-
>   Documentation/sound/alsa/HD-Audio.txt              |    2 +-
>   Documentation/sound/alsa/soc/DAI.txt               |    2 +-
>   Documentation/sound/alsa/soc/codec.txt             |    2 +-
>   Documentation/sound/alsa/soc/platform.txt          |    2 +-
>   Documentation/sound/oss/README.OSS                 |    5 +-
>   Documentation/telephony/ixj.txt                    |    9 +--
>   Documentation/uml/UserModeLinux-HOWTO.txt          |   89 ++++----------------
>   Documentation/usb/linux.inf                        |    2 +-
>   Documentation/usb/mtouchusb.txt                    |    6 +-
>   Documentation/usb/usb-serial.txt                   |    4 +-
>   Documentation/video4linux/API.html                 |    2 +-
>   Documentation/video4linux/CQcam.txt                |    4 +-
>   Documentation/video4linux/README.cpia              |    2 +-
>   Documentation/video4linux/README.ivtv              |    2 +-
>   Documentation/video4linux/Zoran                    |    6 +-
>   Documentation/video4linux/bttv/Cards               |    6 +-
>   Documentation/video4linux/bttv/MAKEDEV             |    2 +-
>   Documentation/video4linux/bttv/Specs               |    4 +-
>   .../video4linux/cx88/hauppauge-wintv-cx88-ir.txt   |    2 +-
>   .../video4linux/hauppauge-wintv-cx88-ir.txt        |    2 +-
>   Documentation/video4linux/ibmcam.txt               |    5 +-
>   Documentation/video4linux/se401.txt                |    2 +-
>   Documentation/video4linux/w9966.txt                |    2 +-
>   Documentation/w1/masters/ds2482                    |    4 +-
>   Documentation/w1/masters/mxc-w1                    |    3 +-
>   Documentation/w1/masters/omap-hdq                  |    2 +-
>   Documentation/zh_CN/HOWTO                          |    8 +-
>   Documentation/zh_CN/SubmittingDrivers              |    2 +-
>   Documentation/zh_CN/SubmittingPatches              |    6 +-
>   138 files changed, 247 insertions(+), 339 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
> index aba7d98..7405de2 100644
> --- a/Documentation/ABI/testing/sysfs-devices-memory
> +++ b/Documentation/ABI/testing/sysfs-devices-memory
> @@ -7,7 +7,7 @@ Description:
>   		added or removed dynamically to represent hot-add/remove
>   		operations.
>   Users:		hotplug memory add/remove tools
> -		https://w3.opensource.ibm.com/projects/powerpc-utils/
> +		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
>
>   What:		/sys/devices/system/memory/memoryX/removable
>   Date:		June 2008
> @@ -19,7 +19,7 @@ Description:
>   		identify removable sections of the memory before attempting
>   		potentially expensive hot-remove memory operation
>   Users:		hotplug memory remove tools
> -		https://w3.opensource.ibm.com/projects/powerpc-utils/
> +		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils	
>
>   What:		/sys/devices/system/memory/memoryX/phys_device
>   Date:		September 2008
> @@ -58,7 +58,7 @@ Description:
>   		by root to offline that section.
>   		# echo offline>  /sys/devices/system/memory/memory22/state
>   Users:		hotplug memory remove tools
> -		https://w3.opensource.ibm.com/projects/powerpc-utils/
> +		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
>
>
>   What:		/sys/devices/system/memoryX/nodeY
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 84a710f..7564e88 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -197,7 +197,7 @@ Description:	These files exist in every cpu's cache index directories.
>   		Currently, only AMD Family 10h Processors support cache index
>   		disable, and only for their L3 caches.  See the BIOS and
>   		Kernel Developer's Guide at
> -		http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/31116-Public-GH-BKDG_3.20_2-4-09.pdf
> +		http://support.amd.com/us/Embedded_TechDocs/31116-Public-GH-BKDG_3-28_5-28-09.pdf	
>   		for formatting information and other details on the
>   		cache index disable.
>   Users:    joachim.deguara@amd.com
> diff --git a/Documentation/DocBook/scsi.tmpl b/Documentation/DocBook/scsi.tmpl
> index d87f456..324b534 100644
> --- a/Documentation/DocBook/scsi.tmpl
> +++ b/Documentation/DocBook/scsi.tmpl
> @@ -393,7 +393,7 @@
>           </para>
>           <para>
>             For documentation see
> -<ulink url='http://www.torque.net/sg/sdebug26.html'>http://www.torque.net/sg/sdebug26.html</ulink>
> +<ulink url='http://sg.danny.cz/sg/sdebug26.html'>http://sg.danny.cz/sg/sdebug26.html</ulink>
>           </para>
>   <!-- !Edrivers/scsi/scsi_debug.c -->
>         </sect2>
> diff --git a/Documentation/DocBook/v4l/compat.xml b/Documentation/DocBook/v4l/compat.xml
> index b42b935..54447f0 100644
> --- a/Documentation/DocBook/v4l/compat.xml
> +++ b/Documentation/DocBook/v4l/compat.xml
> @@ -1091,8 +1091,9 @@ signed 64-bit integer. Output devices should not send a buffer out
>   until the time in the timestamp field has arrived. I would like to
>   follow SGI's lead, and adopt a multimedia timestamping system like
>   their UST (Unadjusted System Time). See
> -http://reality.sgi.com/cpirazzi_engr/lg/time/intro.html. [This link is
> -no longer valid.] UST uses timestamps that are 64-bit signed integers
> +http://web.archive.org/web/*/http://reality.sgi.com
> +/cpirazzi_engr/lg/time/intro.html.
> +UST uses timestamps that are 64-bit signed integers
>   (not struct timeval's) and given in nanosecond units. The UST clock
>   starts at zero when the system is booted and runs continuously and
>   uniformly. It takes a little over 292 years for UST to overflow. There
> diff --git a/Documentation/DocBook/v4l/fdl-appendix.xml b/Documentation/DocBook/v4l/fdl-appendix.xml
> index b6ce50d..ae22394 100644
> --- a/Documentation/DocBook/v4l/fdl-appendix.xml
> +++ b/Documentation/DocBook/v4l/fdl-appendix.xml
> @@ -2,7 +2,7 @@
>        The GNU Free Documentation License 1.1 in DocBook
>        Markup by Eric Baudais<baudais@okstate.edu>
>        Maintained by the GNOME Documentation Project
> -     http://developer.gnome.org/projects/gdp
> +     http://live.gnome.org/DocumentationProject
>        Version: 1.0.1
>        Last Modified: Nov 16, 2000
>   -->
> diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> index 40ada93..365bda9 100644
> --- a/Documentation/HOWTO
> +++ b/Documentation/HOWTO
> @@ -187,7 +187,7 @@ apply a patch.
>   If you do not know where you want to start, but you want to look for
>   some task to start doing to join into the kernel development community,
>   go to the Linux Kernel Janitor's project:
> -	http://janitor.kernelnewbies.org/
> +	http://kernelnewbies.org/KernelJanitors	
>   It is a great place to start.  It describes a list of relatively simple
>   problems that need to be cleaned up and fixed within the Linux kernel
>   source tree.  Working with the developers in charge of this project, you
> @@ -315,7 +315,7 @@ process is tracked with the tool patchwork.  Patchwork offers a web
>   interface which shows patch postings, any comments on a patch or
>   revisions to it, and maintainers can mark patches as under review,
>   accepted, or rejected.  Most of these patchwork sites are listed at
> -http://patchwork.kernel.org/ or http://patchwork.ozlabs.org/.
> +http://patchwork.kernel.org/.
>
>   2.6.x -next kernel tree for integration tests
>   ---------------------------------------------
> @@ -595,7 +595,7 @@ start exactly where you are now.
>
>   ----------
>   Thanks to Paolo Ciarrocchi who allowed the "Development Process"
> -(http://linux.tar.bz/articles/2.6-development_process) section
> +(http://lwn.net/Articles/94386/) section
>   to be based on text he had written, and to Randy Dunlap and Gerrit
>   Huizenga for some of the list of things you should and should not say.
>   Also thanks to Pat Mochel, Hanna Linder, Randy Dunlap, Kay Sievers,
> diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
> index 5aea459..c43460d 100644
> --- a/Documentation/RCU/RTFP.txt
> +++ b/Documentation/RCU/RTFP.txt
> @@ -606,7 +606,7 @@ Suparna Bhattacharya"
>   ,Year="2006"
>   ,pages="v2 123-138"
>   ,note="Available:
> -\url{http://www.linuxsymposium.org/2006/view_abstract.php?content_key=184}
> +\url{http://www.linuxsymposium.org/2006/index_2006.php}
>   \url{http://www.rdrop.com/users/paulmck/RCU/OLSrtRCU.2006.08.11a.pdf}
>   [Viewed January 1, 2007]"
>   ,annotation="
> diff --git a/Documentation/SubmittingDrivers b/Documentation/SubmittingDrivers
> index 4947fd8..38d2aab 100644
> --- a/Documentation/SubmittingDrivers
> +++ b/Documentation/SubmittingDrivers
> @@ -161,7 +161,7 @@ How to NOT write kernel driver by Arjan van de Ven:
>   	http://www.fenrus.org/how-to-not-write-a-device-driver-paper.pdf
>
>   Kernel Janitor:
> -	http://janitor.kernelnewbies.org/
> +	http://kernelnewbies.org/KernelJanitors
>
>   GIT, Fast Version Control System:
>   	http://git-scm.com/
> diff --git a/Documentation/aoe/aoe.txt b/Documentation/aoe/aoe.txt
> index 3a4dbe4..b5aada9 100644
> --- a/Documentation/aoe/aoe.txt
> +++ b/Documentation/aoe/aoe.txt
> @@ -1,6 +1,6 @@
>   The EtherDrive (R) HOWTO for users of 2.6 kernels is found at ...
>
> -  http://www.coraid.com/support/linux/EtherDrive-2.6-HOWTO.html
> +  http://www.coraid.com/SUPPORT/EtherDrive-HBA
>
>     It has many tips and hints!
>
> diff --git a/Documentation/arm/IXP2000 b/Documentation/arm/IXP2000
> index e0148b6..68d21d9 100644
> --- a/Documentation/arm/IXP2000
> +++ b/Documentation/arm/IXP2000
> @@ -14,7 +14,7 @@ telecom systems. In addition to an XScale core, it contains up to 8
>   interfaces (UTOPIA, SPI, etc), a PCI host bridge, one serial port,
>   flash interface, and some other odds and ends. For more information, see:
>
> -http://developer.intel.com/design/network/products/npfamily/ixp2xxx.htm
> +http://developer.intel.com
>
>   2. Linux Support
>
> diff --git a/Documentation/arm/IXP4xx b/Documentation/arm/IXP4xx
> index 72fbcc4..133c5fa 100644
> --- a/Documentation/arm/IXP4xx
> +++ b/Documentation/arm/IXP4xx
> @@ -45,7 +45,7 @@ require the use of Intel's propietary CSR softare:
>   If you need to use any of the above, you need to download Intel's
>   software from:
>
> -   http://developer.intel.com/design/network/products/npfamily/ixp425swr1.htm
> +   http://developer.intel.com/design/network/products/npfamily/ixp425.htm
>
>   DO NOT POST QUESTIONS TO THE LINUX MAILING LISTS REGARDING THE PROPIETARY
>   SOFTWARE.
> @@ -53,7 +53,7 @@ SOFTWARE.
>   There are several websites that provide directions/pointers on using
>   Intel's software:
>
> -http://ixp4xx-osdg.sourceforge.net/
> +   http://sourceforge.net/projects/ixp4xx-osdg/
>      Open Source Developer's Guide for using uClinux and the Intel libraries
>
>   http://gatewaymaker.sourceforge.net/
> @@ -112,21 +112,21 @@ http://www.adiengineering.com/productsCoyote.html
>      Finally, there is an IDE port hanging off the expansion bus.
>
>   Gateworks Avila Network Platform
> -http://www.gateworks.com/avila_sbc.htm
> +http://www.gateworks.com/support/overview.php
>
>      The Avila platform is basically and IXDP425 with the 4 PCI slots
>      replaced with mini-PCI slots and a CF IDE interface hanging off
>      the expansion bus.
>
>   Intel IXDP425 Development Platform
> -http://developer.intel.com/design/network/products/npfamily/ixdp425.htm
> +http://www.intel.com/design/network/products/npfamily/ixdpg425.htm
>
>      This is Intel's standard reference platform for the IXDP425 and is
>      also known as the Richfield board. It contains 4 PCI slots, 16MB
>      of flash, two 10/100 ports and one ADSL port.
>
>   Intel IXDP465 Development Platform
> -http://developer.intel.com/design/network/products/npfamily/ixdp465.htm
> +http://www.intel.com/design/network/products/npfamily/ixdp465.htm
>
>      This is basically an IXDP425 with an IXP465 and 32M of flash instead
>      of just 16.
> @@ -141,15 +141,13 @@ Intel IXDPG425 Development Platform
>      a pivot_root to NFS.
>
>   Motorola PrPMC1100 Processor Mezanine Card
> -http://www.fountainsys.com/datasheet/PrPMC1100.pdf
> +http://www.fountainsys.com
>
>      The PrPMC1100 is based on the IXCP1100 and is meant to plug into
>      and IXP2400/2800 system to act as the system controller. It simply
>      contains a CPU and 16MB of flash on the board and needs to be
>      plugged into a carrier board to function. Currently Linux only
>      supports the Motorola PrPMC carrier board for this platform.
> -   See https://mcg.motorola.com/us/ds/pdf/ds0144.pdf for info
> -   on the carrier board.
>
>   5. TODO LIST
>
> diff --git a/Documentation/arm/README b/Documentation/arm/README
> index d98783f..aea3409 100644
> --- a/Documentation/arm/README
> +++ b/Documentation/arm/README
> @@ -41,12 +41,12 @@ Bug reports etc
>   ---------------
>
>     Please send patches to the patch system.  For more information, see
> -  http://www.arm.linux.org.uk/patches/info.html  Always include some
> +  http://www.arm.linux.org.uk/developer/patches/info.php Always include some
>     explanation as to what the patch does and why it is needed.
>
>     Bug reports should be sent to linux-arm-kernel@lists.arm.linux.org.uk,
>     or submitted through the web form at
> -  http://www.arm.linux.org.uk/forms/solution.shtml
> +  http://www.arm.linux.org.uk/developer/
>
>     When sending bug reports, please ensure that they contain all relevant
>     information, eg. the kernel messages that were printed before/during
> diff --git a/Documentation/arm/SA1100/Assabet b/Documentation/arm/SA1100/Assabet
> index 91f7ce7..08b885d 100644
> --- a/Documentation/arm/SA1100/Assabet
> +++ b/Documentation/arm/SA1100/Assabet
> @@ -2,8 +2,7 @@ The Intel Assabet (SA-1110 evaluation) board
>   ============================================
>
>   Please see:
> -http://developer.intel.com/design/strong/quicklist/eval-plat/sa-1110.htm
> -http://developer.intel.com/design/strong/guides/278278.htm
> +http://developer.intel.com
>
>   Also some notes from John G Dorsey<jd5q@andrew.cmu.edu>:
>   http://www.cs.cmu.edu/~wearable/software/assabet.html
> @@ -64,7 +63,7 @@ Initial RedBoot configuration
>   -----------------------------
>
>   The commands used here are explained in The RedBoot User's Guide available
> -on-line at http://sources.redhat.com/ecos/docs-latest/redboot/redboot.html.
> +on-line at http://sources.redhat.com/ecos/docs.html.
>   Please refer to it for explanations.
>
>   If you have a CF network card (my Assabet kit contained a CF+ LP-E from
> diff --git a/Documentation/arm/SA1100/Brutus b/Documentation/arm/SA1100/Brutus
> index b1cfd40..6a3aa95 100644
> --- a/Documentation/arm/SA1100/Brutus
> +++ b/Documentation/arm/SA1100/Brutus
> @@ -1,7 +1,7 @@
>   Brutus is an evaluation platform for the SA1100 manufactured by Intel.
>   For more details, see:
>
> -http://developer.intel.com/design/strong/applnots/sa1100lx/getstart.htm
> +http://developer.intel.com
>
>   To compile for Brutus, you must issue the following commands:
>
> diff --git a/Documentation/arm/SA1100/FreeBird b/Documentation/arm/SA1100/FreeBird
> index eda28b3..fb23b77 100644
> --- a/Documentation/arm/SA1100/FreeBird
> +++ b/Documentation/arm/SA1100/FreeBird
> @@ -1,5 +1,5 @@
>   Freebird-1.1 is produced by Legned(C) ,Inc.
> -(http://www.legend.com.cn)
> +http://web.archive.org/web/*/http://www.legend.com.cn
>   and software/linux mainatined by Coventive(C),Inc.
>   (http://www.coventive.com)
>
> diff --git a/Documentation/arm/SA1100/GraphicsClient b/Documentation/arm/SA1100/GraphicsClient
> index 6c9c4f5..867bb35 100644
> --- a/Documentation/arm/SA1100/GraphicsClient
> +++ b/Documentation/arm/SA1100/GraphicsClient
> @@ -71,7 +71,7 @@ Supported peripherals:
>   - serial ports (ttyS[0-2])
>     - ttyS0 is default for serial console
>   - Smart I/O (ADC, keypad, digital inputs, etc)
> -  See http://www.applieddata.com/developers/linux for IOCTL documentation
> +  See http://www.eurotech-inc.com/linux-sbc.asp for IOCTL documentation
>     and example user space code. ps/2 keybd is multiplexed through this driver
>
>   To do:
> diff --git a/Documentation/arm/SA1100/GraphicsMaster b/Documentation/arm/SA1100/GraphicsMaster
> index ee7c659..9145088 100644
> --- a/Documentation/arm/SA1100/GraphicsMaster
> +++ b/Documentation/arm/SA1100/GraphicsMaster
> @@ -28,7 +28,7 @@ Supported peripherals:
>   - serial ports (ttyS[0-2])
>     - ttyS0 is default for serial console
>   - Smart I/O (ADC, keypad, digital inputs, etc)
> -  See http://www.applieddata.com/developers/linux for IOCTL documentation
> +  See http://www.eurotech-inc.com/linux-sbc.asp for IOCTL documentation
>     and example user space code. ps/2 keybd is multiplexed through this driver
>
>   To do:
> diff --git a/Documentation/arm/SA1100/Itsy b/Documentation/arm/SA1100/Itsy
> index 3b59453..44b9499 100644
> --- a/Documentation/arm/SA1100/Itsy
> +++ b/Documentation/arm/SA1100/Itsy
> @@ -4,7 +4,7 @@ research projects at Compaq that are related to pocket computing.
>
>   For more information, see:
>
> -	http://www.research.digital.com/wrl/itsy/index.html
> +	http://www.hpl.hp.com/downloads/crl/itsy/
>
>   Notes on initial 2.4 Itsy support (8/27/2000) :
>   The port was done on an Itsy version 1.5 machine with a daughtercard with
> diff --git a/Documentation/arm/SA1100/PLEB b/Documentation/arm/SA1100/PLEB
> index 92cae06..b9c8a63 100644
> --- a/Documentation/arm/SA1100/PLEB
> +++ b/Documentation/arm/SA1100/PLEB
> @@ -6,6 +6,6 @@ PLEB support has yet to be fully integrated.
>
>   For more information, see:
>
> -	http://www.cse.unsw.edu.au/~pleb/
> +	http://www.cse.unsw.edu.au
>
>
> diff --git a/Documentation/arm/SA1100/Victor b/Documentation/arm/SA1100/Victor
> index f938a29..9cff415 100644
> --- a/Documentation/arm/SA1100/Victor
> +++ b/Documentation/arm/SA1100/Victor
> @@ -3,7 +3,7 @@ VisuAide, Inc. to be used by blind people.
>
>   For more information related to Victor, see:
>
> -	http://www.visuaide.com/victor
> +	http://www.humanware.com/en-usa/products
>
>   Of course Victor is using Linux as its main operating system.
>   The Victor implementation for Linux is maintained by Nicolas Pitre:
> diff --git a/Documentation/arm/SA1100/nanoEngine b/Documentation/arm/SA1100/nanoEngine
> index fc431cb..48a7934 100644
> --- a/Documentation/arm/SA1100/nanoEngine
> +++ b/Documentation/arm/SA1100/nanoEngine
> @@ -7,5 +7,5 @@ for more info.
>   (Ref: Stuart Adams<sja@brightstareng.com>)
>
>   Also visit Larry Doolittle's "Linux for the nanoEngine" site:
> -http://recycle.lbl.gov/~ldoolitt/bse/
> +http://www.brightstareng.com/arm/nanoeng.htm
>
> diff --git a/Documentation/binfmt_misc.txt b/Documentation/binfmt_misc.txt
> index f609ebf..c1ed694 100644
> --- a/Documentation/binfmt_misc.txt
> +++ b/Documentation/binfmt_misc.txt
> @@ -111,6 +111,6 @@ cause unexpected behaviour and can be a security hazard.
>
>
>   There is a web page about binfmt_misc at
> -http://www.tat.physik.uni-tuebingen.de/~rguenth/linux/binfmt_misc.html
> +http://www.tat.physik.uni-tuebingen.de
>
>   Richard Günther<rguenth@tat.physik.uni-tuebingen.de>
> diff --git a/Documentation/blockdev/paride.txt b/Documentation/blockdev/paride.txt
> index e431267..ee6717e 100644
> --- a/Documentation/blockdev/paride.txt
> +++ b/Documentation/blockdev/paride.txt
> @@ -412,6 +412,6 @@ have in your mail headers, when sending mail to the list server.
>   You might also find some useful information on the linux-parport
>   web pages (although they are not always up to date) at
>
> -	http://www.torque.net/parport/
> +	http://web.archive.org/web/*/http://www.torque.net/parport/
>
>
> diff --git a/Documentation/cdrom/packet-writing.txt b/Documentation/cdrom/packet-writing.txt
> index 1c40777..13c251d 100644
> --- a/Documentation/cdrom/packet-writing.txt
> +++ b/Documentation/cdrom/packet-writing.txt
> @@ -95,7 +95,7 @@ Using the pktcdvd sysfs interface
>
>   Since Linux 2.6.20, the pktcdvd module has a sysfs interface
>   and can be controlled by it. For example the "pktcdvd" tool uses
> -this interface. (see http://people.freenet.de/BalaGi#pktcdvd )
> +this interface. (see http://tom.ist-im-web.de/download/pktcdvd )
>
>   "pktcdvd" works similar to "pktsetup", e.g.:
>
> diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
> index 51682ab..5d0d569 100644
> --- a/Documentation/cgroups/cpusets.txt
> +++ b/Documentation/cgroups/cpusets.txt
> @@ -691,7 +691,7 @@ There are ways to query or modify cpusets:
>      cat, rmdir commands from the shell, or their equivalent from C.
>    - via the C library libcpuset.
>    - via the C library libcgroup.
> -   (http://sourceforge.net/proects/libcg/)
> +   (http://sourceforge.net/projects/libcg/)
>    - via the python application cset.
>      (http://developer.novell.com/wiki/index.php/Cpuset)
>
> diff --git a/Documentation/development-process/4.Coding b/Documentation/development-process/4.Coding
> index a5a3450..2278693 100644
> --- a/Documentation/development-process/4.Coding
> +++ b/Documentation/development-process/4.Coding
> @@ -281,7 +281,7 @@ With sparse, the programmer can be warned about confusion between
>   user-space and kernel-space addresses, mixture of big-endian and
>   small-endian quantities, the passing of integer values where a set of bit
>   flags is expected, and so on.  Sparse must be installed separately (it can
> -be found at http://www.kernel.org/pub/software/devel/sparse/ if your
> +be found at https://sparse.wiki.kernel.org/index.php/Main_Page if your
>   distributor does not package it); it can then be run on the code by adding
>   "C=1" to your make command.
>
> diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
> index 6680cab..524de92 100644
> --- a/Documentation/device-mapper/dm-crypt.txt
> +++ b/Documentation/device-mapper/dm-crypt.txt
> @@ -36,7 +36,7 @@ Example scripts
>   ===============
>   LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
>   encryption with dm-crypt using the 'cryptsetup' utility, see
> -http://luks.endorphin.org/
> +http://clemens.endorphin.org/cryptography
>
>   [[
>   #!/bin/sh
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 1d83d12..f2da781 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -1517,7 +1517,7 @@ Your cooperation is appreciated.
>   		    ...
>
>   		The driver and documentation may be obtained from
> -		http://www.proximity.com.au/~brian/winradio/
> +		http://www.winradio.com/
>
>    82 block	I2O hard disk
>   		  0 = /dev/i2o/hdag	33rd I2O hard disk, whole disk
> @@ -1723,7 +1723,7 @@ Your cooperation is appreciated.
>   		  1 = /dev/comedi1	Second comedi device
>   		    ...
>
> -		See http://stm.lbl.gov/comedi or http://www.llp.fu-berlin.de/.
> +		See http://stm.lbl.gov/comedi.
>
>    98 block	User-mode virtual block device
>   		  0 = /dev/ubda		First user-mode block device
> @@ -1984,7 +1984,7 @@ Your cooperation is appreciated.
>                   256 NetWare volumes can be supported in a single
>                   machine.
>
> -                http://www.kernel.org/pub/linux/kernel/people/jmerkey/nwfs
> +                http://cgfa.telepac.pt/ftp2/kernel.org/linux/kernel/people/jmerkey/nwfs/
>
>                   0 = /dev/nwfs/v0    First NetWare (NWFS) Logical Volume
>                   1 = /dev/nwfs/v1    Second NetWare (NWFS) Logical Volume
> @@ -2591,7 +2591,8 @@ Your cooperation is appreciated.
>   		  1 = /dev/intermezzo1	Second cache manager
>   		    ...
>
> -		See http://www.inter-mezzo.org/ for more information.
> +		See http://web.archive.org/web/20080115195241/
> +		http://inter-mezzo.org/index.html
>
>   186 char	Object-based storage control device
>   		  0 = /dev/obd0		First obd control device
> diff --git a/Documentation/dvb/faq.txt b/Documentation/dvb/faq.txt
> index 2511a33..121832e 100644
> --- a/Documentation/dvb/faq.txt
> +++ b/Documentation/dvb/faq.txt
> @@ -76,7 +76,7 @@ Some very frequently asked questions about linuxtv-dvb
>   		the TuxBox CVS many interesting DVB applications and the dBox2
>   		DVB source
>
> -	http://sourceforge.net/projects/dvbsak/
> +	http://www.linuxtv.org/downloads/	
>   		DVB Swiss Army Knife library and utilities
>
>   	http://www.nenie.org/misc/mpsys/
> diff --git a/Documentation/fb/framebuffer.txt b/Documentation/fb/framebuffer.txt
> index fe79e3c..58c5ae2 100644
> --- a/Documentation/fb/framebuffer.txt
> +++ b/Documentation/fb/framebuffer.txt
> @@ -330,7 +330,7 @@ and on its mirrors.
>
>   The latest version of fbset can be found at
>
> -    http://home.tvd.be/cr26864/Linux/fbdev/
> +    http://www.linux-fbdev.org/
>
>
>   10. Credits
> diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
> index c0236e7..f9765e8 100644
> --- a/Documentation/filesystems/9p.txt
> +++ b/Documentation/filesystems/9p.txt
> @@ -128,7 +128,7 @@ OPTIONS
>   RESOURCES
>   =========
>
> -Our current recommendation is to use Inferno (http://www.vitanuova.com/inferno)
> +Our current recommendation is to use Inferno (http://www.vitanuova.com/nferno/index.html)
>   as the 9p server.  You can start a 9p server under Inferno by issuing the
>   following command:
>      ; styxlisten -A tcp!*!564 export '#U*'
> diff --git a/Documentation/filesystems/affs.txt b/Documentation/filesystems/affs.txt
> index 2d15244..81ac488 100644
> --- a/Documentation/filesystems/affs.txt
> +++ b/Documentation/filesystems/affs.txt
> @@ -216,4 +216,4 @@ due to an incompatibility with the Amiga floppy controller.
>
>   If you are interested in an Amiga Emulator for Linux, look at
>
> -http://www.freiburg.linux.de/~uae/
> +http://web.archive.org/web/*/http://www.freiburg.linux.de/~uae/
> diff --git a/Documentation/filesystems/befs.txt b/Documentation/filesystems/befs.txt
> index 67391a1..6e49c36 100644
> --- a/Documentation/filesystems/befs.txt
> +++ b/Documentation/filesystems/befs.txt
> @@ -31,7 +31,7 @@ Current maintainer: Sergey S. Kostyliov<rathamahata@php4.ru>
>
>   WHAT IS THIS DRIVER?
>   ==================
> -This module implements the native filesystem of BeOS<http://www.be.com/>
> +This module implements the native filesystem of BeOS http://www.beincorporated.com/
>   for the linux 2.4.1 and later kernels. Currently it is a read-only
>   implementation.
>
> @@ -61,7 +61,7 @@ step 2.  Configuration&  make kernel
>
>   The linux kernel has many compile-time options. Most of them are beyond the
>   scope of this document. I suggest the Kernel-HOWTO document as a good general
> -reference on this topic.<http://www.linux.com/howto/Kernel-HOWTO.html>
> +reference on this topic. http://www.linuxdocs.org/HOWTOs/Kernel-HOWTO-4.html
>
>   However, to use the BeFS module, you must enable it at configure time.
>
> diff --git a/Documentation/filesystems/isofs.txt b/Documentation/filesystems/isofs.txt
> index 3c367c3..ba0a933 100644
> --- a/Documentation/filesystems/isofs.txt
> +++ b/Documentation/filesystems/isofs.txt
> @@ -41,7 +41,7 @@ Mount options unique to the isofs filesystem.
>     sbsector=xxx  Session begins from sector xxx
>
>   Recommended documents about ISO 9660 standard are located at:
> -http://www.y-adagio.com/public/standards/iso_cdromr/tocont.htm
> +http://www.y-adagio.com/
>   ftp://ftp.ecma.ch/ecma-st/Ecma-119.pdf
>   Quoting from the PDF "This 2nd Edition of Standard ECMA-119 is technically
>   identical with ISO 9660.", so it is a valid and gratis substitute of the
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 9fb6cbe..8fe8895 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -73,9 +73,9 @@ contact Bodo  Bauer  at  bb@ricochet.net.  We'll  be happy to add them to this
>   document.
>
>   The   latest   version    of   this   document   is    available   online   at
> -http://skaro.nightcrawler.com/~bb/Docs/Proc as HTML version.
> +http://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/proc.html
>
> -If  the above  direction does  not works  for you,  ypu could  try the  kernel
> +If  the above  direction does  not works  for you,  you could  try the  kernel
>   mailing  list  at  linux-kernel@vger.kernel.org  and/or try  to  reach  me  at
>   comandante@zaralinux.com.
>
> diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
> index eed520f..ead764b 100644
> --- a/Documentation/filesystems/vfat.txt
> +++ b/Documentation/filesystems/vfat.txt
> @@ -165,7 +165,8 @@ TEST SUITE
>   If you plan to make any modifications to the vfat filesystem, please
>   get the test suite that comes with the vfat distribution at
>
> -  http://bmrc.berkeley.edu/people/chaffee/vfat.html
> +  http://web.archive.org/web/*/http://bmrc.berkeley.edu/
> +  people/chaffee/vfat.html
>
>   This tests quite a few parts of the vfat filesystem and additional
>   tests for new features or untested features would be appreciated.
> diff --git a/Documentation/hwmon/adm1026 b/Documentation/hwmon/adm1026
> index f4327db..d8fabe0 100644
> --- a/Documentation/hwmon/adm1026
> +++ b/Documentation/hwmon/adm1026
> @@ -6,7 +6,7 @@ Supported chips:
>       Prefix: 'adm1026'
>       Addresses scanned: I2C 0x2c, 0x2d, 0x2e
>       Datasheet: Publicly available at the Analog Devices website
> -               http://www.analog.com/en/prod/0,,766_825_ADM1026,00.html
> +               http://www.onsemi.com/PowerSolutions/product.do?id=ADM1026
>
>   Authors:
>           Philip Pokorny<ppokorny@penguincomputing.com>  for Penguin Computing
> diff --git a/Documentation/hwmon/g760a b/Documentation/hwmon/g760a
> index e032eeb..cfc8945 100644
> --- a/Documentation/hwmon/g760a
> +++ b/Documentation/hwmon/g760a
> @@ -5,7 +5,7 @@ Supported chips:
>     * Global Mixed-mode Technology Inc. G760A
>       Prefix: 'g760a'
>       Datasheet: Publicly available at the GMT website
> -      http://www.gmt.com.tw/datasheet/g760a.pdf
> +      http://www.gmt.com.tw/product/datasheet/EDS-760A.pdf
>
>   Author: Herbert Valerio Riedel<hvr@gnu.org>
>
> diff --git a/Documentation/hwmon/gl518sm b/Documentation/hwmon/gl518sm
> index 229f8b7..26f9f3c 100644
> --- a/Documentation/hwmon/gl518sm
> +++ b/Documentation/hwmon/gl518sm
> @@ -5,11 +5,10 @@ Supported chips:
>     * Genesys Logic GL518SM release 0x00
>       Prefix: 'gl518sm'
>       Addresses scanned: I2C 0x2c and 0x2d
> -    Datasheet: http://www.genesyslogic.com/pdf
>     * Genesys Logic GL518SM release 0x80
>       Prefix: 'gl518sm'
>       Addresses scanned: I2C 0x2c and 0x2d
> -    Datasheet: http://www.genesyslogic.com/pdf
> +    Datasheet: http://www.genesyslogic.com/
>
>   Authors:
>           Frodo Looijaard<frodol@dds.nl>,
> diff --git a/Documentation/hwmon/k8temp b/Documentation/hwmon/k8temp
> index 0005c71..716dc24 100644
> --- a/Documentation/hwmon/k8temp
> +++ b/Documentation/hwmon/k8temp
> @@ -5,7 +5,7 @@ Supported chips:
>     * AMD Athlon64/FX or Opteron CPUs
>       Prefix: 'k8temp'
>       Addresses scanned: PCI space
> -    Datasheet: http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/32559.pdf
> +    Datasheet: http://support.amd.com/us/Processor_TechDocs/32559.pdf
>
>   Author: Rudolf Marek
>   Contact: Rudolf Marek<r.marek@assembler.cz>
> diff --git a/Documentation/hwmon/lm85 b/Documentation/hwmon/lm85
> index a76aefe..b98e0e0 100644
> --- a/Documentation/hwmon/lm85
> +++ b/Documentation/hwmon/lm85
> @@ -9,15 +9,15 @@ Supported chips:
>     * Analog Devices ADM1027
>       Prefix: 'adm1027'
>       Addresses scanned: I2C 0x2c, 0x2d, 0x2e
> -    Datasheet: http://www.analog.com/en/prod/0,,766_825_ADM1027,00.html
> +    Datasheet: http://www.onsemi.com/PowerSolutions/product.do?id=ADM1027
>     * Analog Devices ADT7463
>       Prefix: 'adt7463'
>       Addresses scanned: I2C 0x2c, 0x2d, 0x2e
> -    Datasheet: http://www.analog.com/en/prod/0,,766_825_ADT7463,00.html
> +    Datasheet: http://www.onsemi.com/PowerSolutions/product.do?id=ADT7463
>     * SMSC EMC6D100, SMSC EMC6D101
>       Prefix: 'emc6d100'
>       Addresses scanned: I2C 0x2c, 0x2d, 0x2e
> -    Datasheet: http://www.smsc.com/main/tools/discontinued/6d100.pdf
> +    Datasheet: http://www.smsc.com/media/Downloads_Public/discontinued/6d100.pdf
>     * SMSC EMC6D102
>       Prefix: 'emc6d102'
>       Addresses scanned: I2C 0x2c, 0x2d, 0x2e
> diff --git a/Documentation/hwmon/smsc47m1 b/Documentation/hwmon/smsc47m1
> index 42c8431..2a13378 100644
> --- a/Documentation/hwmon/smsc47m1
> +++ b/Documentation/hwmon/smsc47m1
> @@ -7,13 +7,10 @@ Supported chips:
>       Addresses scanned: none, address read from Super I/O config space
>       Prefix: 'smsc47m1'
>       Datasheets:
> -        http://www.smsc.com/main/datasheets/47b27x.pdf
> -        http://www.smsc.com/main/datasheets/47m10x.pdf
> -        http://www.smsc.com/main/datasheets/47m112.pdf
> -        http://www.smsc.com/main/tools/discontinued/47m13x.pdf
> -        http://www.smsc.com/main/datasheets/47m14x.pdf
> -        http://www.smsc.com/main/tools/discontinued/47m15x.pdf
> -        http://www.smsc.com/main/datasheets/47m192.pdf
> +        http://www.smsc.com/media/Downloads_Public/Data_Sheets/47b272.pdf
> +        http://www.smsc.com/media/Downloads_Public/Data_Sheets/47m10x.pdf
> +        http://www.smsc.com/media/Downloads_Public/Data_Sheets/47m112.pdf
> +        http://www.smsc.com/
>     * SMSC LPC47M292
>       Addresses scanned: none, address read from Super I/O config space
>       Prefix: 'smsc47m2'
> diff --git a/Documentation/hwmon/thmc50 b/Documentation/hwmon/thmc50
> index 9639ca9..8a7772a 100644
> --- a/Documentation/hwmon/thmc50
> +++ b/Documentation/hwmon/thmc50
> @@ -9,7 +9,7 @@ Supported chips:
>     * Texas Instruments THMC50
>       Prefix: 'thmc50'
>       Addresses scanned: I2C 0x2c - 0x2e
> -    Datasheet: http://focus.ti.com/docs/prod/folders/print/thmc50.html
> +    Datasheet: http://www.ti.com/
>
>   Author: Krzysztof Helt<krzysztof.h1@wp.pl>
>
> diff --git a/Documentation/hwmon/via686a b/Documentation/hwmon/via686a
> index d651b25..e5f90ab 100644
> --- a/Documentation/hwmon/via686a
> +++ b/Documentation/hwmon/via686a
> @@ -5,7 +5,7 @@ Supported chips:
>     * Via VT82C686A, VT82C686B  Southbridge Integrated Hardware Monitor
>       Prefix: 'via686a'
>       Addresses scanned: ISA in PCI-space encoded address
> -    Datasheet: On request through web form (http://www.via.com.tw/en/support/datasheets/)
> +    Datasheet: On request through web form (http://www.via.com.tw/en/resources/download-center/)
>
>   Authors:
>           Kyösti Mälkki<kmalkki@cc.hut.fi>,
> diff --git a/Documentation/hwmon/w83627hf b/Documentation/hwmon/w83627hf
> index 44dd2bc..fb145e5 100644
> --- a/Documentation/hwmon/w83627hf
> +++ b/Documentation/hwmon/w83627hf
> @@ -5,23 +5,19 @@ Supported chips:
>     * Winbond W83627HF (ISA accesses ONLY)
>       Prefix: 'w83627hf'
>       Addresses scanned: ISA address retrieved from Super I/O registers
> -    Datasheet: http://www.winbond.com/PDF/sheet/w83627hf.pdf
>     * Winbond W83627THF
>       Prefix: 'w83627thf'
>       Addresses scanned: ISA address retrieved from Super I/O registers
> -    Datasheet: http://www.winbond.com/PDF/sheet/w83627thf.pdf
>     * Winbond W83697HF
>       Prefix: 'w83697hf'
>       Addresses scanned: ISA address retrieved from Super I/O registers
> -    Datasheet: http://www.winbond.com/PDF/sheet/697hf.pdf
>     * Winbond W83637HF
>       Prefix: 'w83637hf'
>       Addresses scanned: ISA address retrieved from Super I/O registers
> -    Datasheet: http://www.winbond.com/PDF/sheet/w83637hf.pdf
>     * Winbond W83687THF
>       Prefix: 'w83687thf'
>       Addresses scanned: ISA address retrieved from Super I/O registers
> -    Datasheet: Provided by Winbond on request
> +    Datasheet: Provided by Winbond on request(http://www.winbond.com/hq/enu)
>
>   Authors:
>           Frodo Looijaard<frodol@dds.nl>,
> diff --git a/Documentation/hwmon/w83781d b/Documentation/hwmon/w83781d
> index c91e0b6..ecbc1e4 100644
> --- a/Documentation/hwmon/w83781d
> +++ b/Documentation/hwmon/w83781d
> @@ -9,7 +9,7 @@ Supported chips:
>     * Winbond W83782D
>       Prefix: 'w83782d'
>       Addresses scanned: I2C 0x28 - 0x2f, ISA 0x290 (8 I/O ports)
> -    Datasheet: http://www.winbond.com/PDF/sheet/w83782d.pdf
> +    Datasheet: http://www.winbond.com
>     * Winbond W83783S
>       Prefix: 'w83783s'
>       Addresses scanned: I2C 0x2d
> diff --git a/Documentation/hwmon/w83792d b/Documentation/hwmon/w83792d
> index 14a668e..8a023ce 100644
> --- a/Documentation/hwmon/w83792d
> +++ b/Documentation/hwmon/w83792d
> @@ -5,7 +5,7 @@ Supported chips:
>     * Winbond W83792D
>       Prefix: 'w83792d'
>       Addresses scanned: I2C 0x2c - 0x2f
> -    Datasheet: http://www.winbond.com.tw/E-WINBONDHTM/partner/PDFresult.asp?Pname=1035
> +    Datasheet: http://www.winbond.com.tw
>
>   Author: Chunhao Huang
>   Contact: DZShen<DZShen@Winbond.com.tw>
> diff --git a/Documentation/i2c/busses/i2c-ali1535 b/Documentation/i2c/busses/i2c-ali1535
> index acbc65a..5d46342 100644
> --- a/Documentation/i2c/busses/i2c-ali1535
> +++ b/Documentation/i2c/busses/i2c-ali1535
> @@ -3,7 +3,7 @@ Kernel driver i2c-ali1535
>   Supported adapters:
>     * Acer Labs, Inc. ALI 1535 (south bridge)
>       Datasheet: Now under NDA
> -	http://www.ali.com.tw/eng/support/datasheet_request.php
> +	http://www.ali.com.tw/
>
>   Authors:
>   	Frodo Looijaard<frodol@dds.nl>,
> diff --git a/Documentation/i2c/busses/i2c-ali1563 b/Documentation/i2c/busses/i2c-ali1563
> index 5469169..41b1a07 100644
> --- a/Documentation/i2c/busses/i2c-ali1563
> +++ b/Documentation/i2c/busses/i2c-ali1563
> @@ -3,7 +3,7 @@ Kernel driver i2c-ali1563
>   Supported adapters:
>     * Acer Labs, Inc. ALI 1563 (south bridge)
>       Datasheet: Now under NDA
> -	http://www.ali.com.tw/eng/support/datasheet_request.php
> +	http://www.ali.com.tw/
>
>   Author: Patrick Mochel<mochel@digitalimplant.org>
>
> diff --git a/Documentation/i2c/busses/i2c-ali15x3 b/Documentation/i2c/busses/i2c-ali15x3
> index 600da90..42888d8 100644
> --- a/Documentation/i2c/busses/i2c-ali15x3
> +++ b/Documentation/i2c/busses/i2c-ali15x3
> @@ -3,7 +3,7 @@ Kernel driver i2c-ali15x3
>   Supported adapters:
>     * Acer Labs, Inc. ALI 1533 and 1543C (south bridge)
>       Datasheet: Now under NDA
> -	http://www.ali.com.tw/eng/support/datasheet_request.php
> +	http://www.ali.com.tw/
>
>   Authors:
>   	Frodo Looijaard<frodol@dds.nl>,
> diff --git a/Documentation/i2c/busses/i2c-piix4 b/Documentation/i2c/busses/i2c-piix4
> index ac540c7..475bb4a 100644
> --- a/Documentation/i2c/busses/i2c-piix4
> +++ b/Documentation/i2c/busses/i2c-piix4
> @@ -97,4 +97,4 @@ of all affected systems, so the only safe solution was to prevent access to
>   the SMBus on all IBM systems (detected using DMI data.)
>
>   For additional information, read:
> -http://www.lm-sensors.org/browser/lm-sensors/trunk/README.thinkpad
> +http://www.lm-sensors.org/browser/lm-sensors/trunk/README
> diff --git a/Documentation/i2c/busses/i2c-sis630 b/Documentation/i2c/busses/i2c-sis630
> index 629ea2c..0b96973 100644
> --- a/Documentation/i2c/busses/i2c-sis630
> +++ b/Documentation/i2c/busses/i2c-sis630
> @@ -2,7 +2,7 @@ Kernel driver i2c-sis630
>
>   Supported adapters:
>     * Silicon Integrated Systems Corp (SiS)
> -	630 chipset (Datasheet: available at http://amalysh.bei.t-online.de/docs/SIS/)
> +	630 chipset (Datasheet: available at http://www.sfr-fresh.com/linux)
>   	730 chipset
>     * Possible other SiS chipsets ?
>
> diff --git a/Documentation/ia64/aliasing.txt b/Documentation/ia64/aliasing.txt
> index aa3e953..5a4dea6 100644
> --- a/Documentation/ia64/aliasing.txt
> +++ b/Documentation/ia64/aliasing.txt
> @@ -168,8 +168,6 @@ PAST PROBLEM CASES
>
>       mmap of 0x0-0x9FFFF /dev/mem by "hwinfo" on HP sx1000 with VGA enabled
>
> -      See https://bugzilla.novell.com/show_bug.cgi?id=140858.
> -
>         The EFI memory map reports the following attributes:
>           0x00000-0x9FFFF WB only
>           0xA0000-0xBFFFF UC only (VGA frame buffer)
> diff --git a/Documentation/ia64/serial.txt b/Documentation/ia64/serial.txt
> index 040b977..6869c73 100644
> --- a/Documentation/ia64/serial.txt
> +++ b/Documentation/ia64/serial.txt
> @@ -133,7 +133,7 @@ TROUBLESHOOTING SERIAL CONSOLE PROBLEMS
>
>
>
> -[1] http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
> +[1] http://www.dig64.org/specifications/agreement
>       The table was originally defined as the "HCDP" for "Headless
>       Console/Debug Port."  The current version is the "PCDP" for
>       "Primary Console and Debug Port Devices."
> diff --git a/Documentation/infiniband/user_verbs.txt b/Documentation/infiniband/user_verbs.txt
> index afe3f8d..e5092d6 100644
> --- a/Documentation/infiniband/user_verbs.txt
> +++ b/Documentation/infiniband/user_verbs.txt
> @@ -5,7 +5,7 @@ USERSPACE VERBS ACCESS
>     described in chapter 11 of the InfiniBand Architecture Specification.
>
>     To use the verbs, the libibverbs library, available from
> -<http://openib.org/>, is required.  libibverbs contains a
> +  http://www.openfabrics.org/, is required.  libibverbs contains a
>     device-independent API for using the ib_uverbs interface.
>     libibverbs also requires appropriate device-dependent kernel and
>     userspace driver for your InfiniBand hardware.  For example, to use
> diff --git a/Documentation/input/appletouch.txt b/Documentation/input/appletouch.txt
> index 4f7c633..b13de3f 100644
> --- a/Documentation/input/appletouch.txt
> +++ b/Documentation/input/appletouch.txt
> @@ -82,4 +82,4 @@ Links:
>   ------
>
>   [1]: http://johannes.sipsolutions.net/PowerBook/touchpad/
> -[2]: http://web.telia.com/~u89404340/touchpad/index.html
> +[2]: http://web.archive.org/web/*/http://web.telia.com/~u89404340/touchpad/index.html
> diff --git a/Documentation/input/bcm5974.txt b/Documentation/input/bcm5974.txt
> index 5e22dcf..74d3876 100644
> --- a/Documentation/input/bcm5974.txt
> +++ b/Documentation/input/bcm5974.txt
> @@ -62,4 +62,4 @@ Links
>   -----
>
>   [1] http://ubuntuforums.org/showthread.php?t=840040
> -[2] http://http://bitmath.org/code/
> +[2] http://bitmath.org/code/
> diff --git a/Documentation/input/iforce-protocol.txt b/Documentation/input/iforce-protocol.txt
> index 3ac9241..2d5fbfd 100644
> --- a/Documentation/input/iforce-protocol.txt
> +++ b/Documentation/input/iforce-protocol.txt
> @@ -251,7 +251,7 @@ Check www.immerse.com for Immersion Studio, and www.fcoder.com for ComPortSpy.
>
>   ** Author of this document **
>   Johann Deneux<johann.deneux@gmail.com>
> -Home page at http://www.esil.univ-mrs.fr/~jdeneux/projects/ff/
> +Home page at http://web.archive.org/web/*/http://www.esil.univ-mrs.fr
>
>   Additions by Vojtech Pavlik.
>
> diff --git a/Documentation/input/sentelic.txt b/Documentation/input/sentelic.txt
> index b35affd..b2ef125 100644
> --- a/Documentation/input/sentelic.txt
> +++ b/Documentation/input/sentelic.txt
> @@ -341,7 +341,7 @@ Byte 5~8: Don't care (Absolute packet)
>   FSP supports basic PS/2 commanding set and modes, refer to following URL for
>   details about PS/2 commands:
>
> -http://www.computer-engineering.org/index.php?title=PS/2_Mouse_Interface
> +http://www.computer-engineering.org/ps2mouse/
>
>   ==============================================================================
>   * Programming Sequence for Determining Packet Parsing Flow
> diff --git a/Documentation/input/xpad.txt b/Documentation/input/xpad.txt
> index aae0d40..7cc9a43 100644
> --- a/Documentation/input/xpad.txt
> +++ b/Documentation/input/xpad.txt
> @@ -150,7 +150,7 @@ the basic functionality.
>
>   1. http://euc.jp/periphs/xbox-controller.ja.html (ITO Takayuki)
>   2. http://xpad.xbox-scene.com/
> -3. http://www.xboxhackz.com/Hackz-Reference.htm
> +3. http://www.markosweb.com/www/xboxhackz.com/
>
>   4. /proc/bus/usb/devices - dump from InterAct PowerPad Pro (Germany):
>
> diff --git a/Documentation/intel_txt.txt b/Documentation/intel_txt.txt
> index 5dc59b0..849de1a 100644
> --- a/Documentation/intel_txt.txt
> +++ b/Documentation/intel_txt.txt
> @@ -25,20 +25,18 @@ which has been updated for the new released platforms.
>   Intel TXT has been presented at various events over the past few
>   years, some of which are:
>         LinuxTAG 2008:
> -          http://www.linuxtag.org/2008/en/conf/events/vp-donnerstag/
> -          details.html?talkid=110
> +          http://www.linuxtag.org/2008/en/conf/events/vp-donnerstag.html
>         TRUST2008:
> -          http://www.trust2008.eu/downloads/Keynote-Speakers/
> +          http://www.trust-conference.eu/downloads/Keynote-Speakers/
>             3_David-Grawrock_The-Front-Door-of-Trusted-Computing.pdf
> -      IDF 2008, Shanghai:
> -          http://inteldeveloperforum.com.edgesuite.net/shanghai_2008/
> -          aep/PROS003/index.html
> +      IDF, Shanghai:
> +          http://www.prcidf.com.cn/index_en.html
>         IDFs 2006, 2007 (I'm not sure if/where they are online)
>
>   Trusted Boot Project Overview:
>   =============================
>
> -Trusted Boot (tboot) is an open source, pre- kernel/VMM module that
> +Trusted Boot (tboot) is an open source, pre-kernel/VMM module that
>   uses Intel TXT to perform a measured and verified launch of an OS
>   kernel/VMM.
>
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index dd5806f..2ec3d7d 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -74,7 +74,7 @@ Code  Seq#(hex)	Include File		Comments
>   0x10	00-0F	drivers/char/s390/vmcp.h
>   0x12	all	linux/fs.h
>   		linux/blkpg.h
> -0x1b	all	InfiniBand Subsystem	<http://www.openib.org/>
> +0x1b	all	InfiniBand Subsystem	<http://infiniband.sourceforge.net/>
>   0x20	all	drivers/cdrom/cm206.h
>   0x22	all	scsi/sg.h
>   '#'	00-3F	IEEE 1394 Subsystem	Block for the entire subsystem
> @@ -190,7 +190,7 @@ Code  Seq#(hex)	Include File		Comments
>   '['	00-07	linux/usb/tmc.h		USB Test and Measurement Devices
>   					<mailto:gregkh@suse.de>
>   'a'	all	linux/atm*.h, linux/sonet.h	ATM on linux
> -					<http://lrcwww.epfl.ch/linux-atm/magic.html>
> +					<http://lrcwww.epfl.ch/>
>   'b'	00-FF				conflict! bit3 vme host bridge
>   					<mailto:natalia@nikhefk.nikhef.nl>
>   'b'	00-0F	media/bt819.h		conflict!
> @@ -225,7 +225,7 @@ Code  Seq#(hex)	Include File		Comments
>   'k'	00-0F	linux/spi/spidev.h	conflict!
>   'k'	00-05	video/kyro.h		conflict!
>   'l'	00-3F	linux/tcfs_fs.h		transparent cryptographic file system
> -					<http://mikonos.dia.unisa.it/tcfs>
> +					<http://web.archive.org/web/*/http://mikonos.dia.unisa.it/tcfs>
>   'l'	40-7F	linux/udf_fs_i.h	in development:
>   					<http://sourceforge.net/projects/linux-udf/>
>   'm'	00-09	linux/mmtimer.h		conflict!
> @@ -252,7 +252,7 @@ Code  Seq#(hex)	Include File		Comments
>   					<mailto:giometti@linux.it>
>   'q'	00-1F	linux/serio.h
>   'q'	80-FF	linux/telephony.h	Internet PhoneJACK, Internet LineJACK
> -		linux/ixjuser.h		<http://www.quicknet.net>
> +		linux/ixjuser.h		<http://web.archive.org/web/*/http://www.quicknet.net>
>   'r'	00-1F	linux/msdos_fs.h and fs/fat/dir.c
>   's'	all	linux/cdk.h
>   't'	00-7F	linux/if_ppp.h
> @@ -286,7 +286,7 @@ Code  Seq#(hex)	Include File		Comments
>   0x89	F0-FF	linux/sockios.h		SIOCDEVPRIVATE range
>   0x8B	all	linux/wireless.h
>   0x8C	00-3F				WiNRADiO driver
> -					<http://www.proximity.com.au/~brian/winradio/>
> +					<http://www.winradio.com.au/>
>   0x90	00	drivers/cdrom/sbpcd.h
>   0x92	00-0F	drivers/usb/mon/mon_bin.c
>   0x93	60-7F	linux/auto_fs.h
> diff --git a/Documentation/isdn/README b/Documentation/isdn/README
> index 6783437..cfb1884 100644
> --- a/Documentation/isdn/README
> +++ b/Documentation/isdn/README
> @@ -36,7 +36,7 @@ README for the ISDN-subsystem
>        http://www.mhessler.de/i4lfaq/
>     It can be viewed online, or downloaded in sgml/text/html format.
>     The FAQ can also be viewed online at
> -     http://www.isdn4inux.de/faq/
> +     http://www.isdn4linux.de/faq/
>     or downloaded from
>        ftp://ftp.isdn4linux.de/pub/isdn4linux/FAQ/
>
> diff --git a/Documentation/isdn/README.HiSax b/Documentation/isdn/README.HiSax
> index 031c8d8..99e87a6 100644
> --- a/Documentation/isdn/README.HiSax
> +++ b/Documentation/isdn/README.HiSax
> @@ -486,7 +486,7 @@ Appendix: Teles PCMCIA driver
>   -----------------------------
>
>   See
> -   http://www.stud.uni-wuppertal.de/~ea0141/pcmcia.html
> +   http://www.linux.no/teles_cs.txt
>   for instructions.
>
>   Appendix: Linux and ISDN-leased lines
> diff --git a/Documentation/ja_JP/HOWTO b/Documentation/ja_JP/HOWTO
> index 5547698..347722f 100644
> --- a/Documentation/ja_JP/HOWTO
> +++ b/Documentation/ja_JP/HOWTO
> @@ -223,7 +223,7 @@ web サイトには、コードの構成、サブシステ� 、現在存在す
>   あなたがどこからスタートして良いかわからないが、Linux カーネル開発コミュ
>   ニティに参� して何かすることをさがしている� �合には、Linux kernel
>   Janitor's プロジェクトにいけば良いでしょう -
> -	http://janitor.kernelnewbies.org/
> +	http://kernelnewbies.org/KernelJanitors	
>   ここはそのようなスタートをするのにうってつけの� �所です。ここには、
>   Linux カーネルソースツリーの中に含まれる、きれいにし、修正しなければな
>   らない、単純な問題のリストが記述されています。このプロジェクトに関わる
> @@ -673,7 +673,7 @@ Linux カーネルコミュニティは、一度に大量のコードの塊を
>   じところからスタートしたのですから。
>
>   Paolo Ciarrocchi に感謝、彼は彼の書いた "Development Process"
> -(http://linux.tar.bz/articles/2.6-development_process)セクショ
> +(http://lwn.net/Articles/94386/)セクショ
>   ンをこのテキストの原型にすることを許可してくれました。
>   Rundy Dunlap と Gerrit Huizenga はメーリングリストでやるべきこととやっ
>   てはいけないことのリストを提供してくれました。
> diff --git a/Documentation/ja_JP/SubmittingPatches b/Documentation/ja_JP/SubmittingPatches
> index a9dc124..f107c83 100644
> --- a/Documentation/ja_JP/SubmittingPatches
> +++ b/Documentation/ja_JP/SubmittingPatches
> @@ -97,7 +97,7 @@ Quilt:
>   http://savannah.nongnu.org/projects/quilt
>
>   Andrew Morton's patch scripts:
> -http://www.zip.com.au/~akpm/linux/patches/
> +http://userweb.kernel.org/~akpm/stuff/tpp.txt
>   このリンクの先のスクリプトの代わりとして、quilt がパッチマネジメント
>   ツールとして推奨されています(上のリンクを見てく� さい)。
>
> @@ -210,7 +210,7 @@ VGER.KERNEL.ORG でホスティングされているメーリングリストの
>    ・移植性のないコードから移植性のあるコードへの置き換え(小さい範囲で
>      あればアーキテクチャ特有のことでも他の人がコピーできます)
>    ・作者やメンテナによる修正(すなわち patch monkey の再転送モード)
> -URL:<http://www.kernel.org/pub/linux/kernel/people/bunk/trivial/>
> +EMAIL:<trivial@kernel.org>
>
>   7) MIME やリンクや圧縮ファイルや添付ファイルではなくプレインテキストのみ
>
> @@ -534,7 +534,7 @@ gcc においては、マクロと同じくらい軽いです。
>   ----------------------
>
>   Andrew Morton, "The perfect patch" (tpp).
> -<http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt>
> +<http://userweb.kernel.org/~akpm/stuff/tpp.txt>
>
>   Jeff Garzik, "Linux kernel patch submission format".
>     <http://linux.yyz.us/patch-format.html>
> diff --git a/Documentation/kernel-docs.txt b/Documentation/kernel-docs.txt
> index ec8d31e..715eaaf 100644
> --- a/Documentation/kernel-docs.txt
> +++ b/Documentation/kernel-docs.txt
> @@ -75,7 +75,7 @@
>
>        * Title: "Conceptual Architecture of the Linux Kernel"
>          Author: Ivan T. Bowman.
> -       URL: http://plg.uwaterloo.ca/~itbowman/papers/CS746G-a1.html
> +       URL: http://plg.uwaterloo.ca/
>          Keywords: conceptual software architecture, extracted design,
>          reverse engineering, system structure.
>          Description: Conceptual software architecture of the Linux kernel,
> @@ -84,7 +84,7 @@
>
>        * Title: "Concrete Architecture of the Linux Kernel"
>          Author: Ivan T. Bowman, Saheem Siddiqi, and Meyer C. Tanuan.
> -       URL: http://plg.uwaterloo.ca/~itbowman/papers/CS746G-a2.html
> +       URL: http://plg.uwaterloo.ca/
>          Keywords: concrete architecture, extracted design, reverse
>          engineering, system structure, dependencies.
>          Description: Concrete architecture of the Linux kernel,
> @@ -95,7 +95,7 @@
>        * Title: "Linux as a Case Study: Its Extracted Software
>          Architecture"
>          Author: Ivan T. Bowman, Richard C. Holt and Neil V. Brewster.
> -       URL: http://plg.uwaterloo.ca/~itbowman/papers/linuxcase.html
> +       URL: http://plg.uwaterloo.ca/
>          Keywords: software architecture, architecture recovery,
>          redocumentation.
>          Description: Paper appeared at ICSE'99, Los Angeles, May 16-22,
> @@ -104,7 +104,7 @@
>
>        * Title: "Overview of the Virtual File System"
>          Author: Richard Gooch.
> -       URL: http://www.atnf.csiro.au/~rgooch/linux/vfs.txt
> +       URL: http://www.mjmwired.net/kernel/Documentation/filesystems/vfs.txt
>          Keywords: VFS, File System, mounting filesystems, opening files,
>          dentries, dcache.
>          Description: Brief introduction to the Linux Virtual File System.
> @@ -267,15 +267,13 @@
>        * Title: "Kernel API changes from 2.0 to 2.2"
>          Author: Richard Gooch.
>          URL:
> -       http://www.atnf.csiro.au/~rgooch/linux/docs/porting-to-2.2.html
> +       http://www.linuxhq.com/guides/LKMPG/node28.html
>          Keywords: 2.2, changes.
>          Description: Kernel functions/structures/variables which changed
>          from 2.0.x to 2.2.x.
>
>        * Title: "Kernel API changes from 2.2 to 2.4"
>          Author: Richard Gooch.
> -       URL:
> -       http://www.atnf.csiro.au/~rgooch/linux/docs/porting-to-2.4.html
>          Keywords: 2.4, changes.
>          Description: Kernel functions/structures/variables which changed
>          from 2.2.x to 2.4.x.
> @@ -290,7 +288,6 @@
>
>        * Title: "I/O Event Handling Under Linux"
>          Author: Richard Gooch.
> -       URL: http://www.atnf.csiro.au/~rgooch/linux/docs/io-events.html
>          Keywords: IO, I/O, select(2), poll(2), FDs, aio_read(2), readiness
>          event queues.
>          Description: From the Introduction: "I/O Event handling is about
> @@ -386,64 +383,64 @@
>
>        * Title: "Porting Device Drivers To Linux 2.2: part II"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/1999-06/gear_01.html
> +       URL: http://www.linux-mag.com/id/238
>          Keywords: ports, porting.
>          Description: Second part on porting from 2.0 to 2.2 kernels.
>
>        * Title: "How To Make Sure Your Driver Will Work On The Power
>          Macintosh"
>          Author: Paul Mackerras.
> -       URL: http://www.linux-mag.com/1999-07/gear_01.html
> +       URL: http://www.linux-mag.com/id/261
>          Keywords: Mac, Power Macintosh, porting, drivers, compatibility.
>          Description: The title says it all.
>
>        * Title: "An Introduction to SCSI Drivers"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/1999-08/gear_01.html
> +       URL: http://www.linux-mag.com/id/284
>          Keywords: SCSI, device, driver.
>          Description: The title says it all.
>
>        * Title: "Advanced SCSI Drivers And Other Tales"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/1999-09/gear_01.html
> +       URL: http://www.linux-mag.com/id/307
>          Keywords: SCSI, device, driver, advanced.
>          Description: The title says it all.
>
>        * Title: "Writing Linux Mouse Drivers"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/1999-10/gear_01.html
> +       URL: http://www.linux-mag.com/id/330
>          Keywords: mouse, driver, gpm.
>          Description: The title says it all.
>
>        * Title: "More on Mouse Drivers"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/1999-11/gear_01.html
> +       URL: http://www.linux-mag.com/id/356
>          Keywords: mouse, driver, gpm, races, asynchronous I/O.
>          Description: The title still says it all.
>
>        * Title: "Writing Video4linux Radio Driver"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/1999-12/gear_01.html
> +       URL: http://www.linux-mag.com/id/381
>          Keywords: video4linux, driver, radio, radio devices.
>          Description: The title says it all.
>
>        * Title: "Video4linux Drivers, Part 1: Video-Capture Device"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/2000-01/gear_01.html
> +       URL: http://www.linux-mag.com/id/406
>          Keywords: video4linux, driver, video capture, capture devices,
>          camera driver.
>          Description: The title says it all.
>
>        * Title: "Video4linux Drivers, Part 2: Video-capture Devices"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/2000-02/gear_01.html
> +       URL: http://www.linux-mag.com/id/429
>          Keywords: video4linux, driver, video capture, capture devices,
>          camera driver, control, query capabilities, capability, facility.
>          Description: The title says it all.
>
>        * Title: "PCI Management in Linux 2.2"
>          Author: Alan Cox.
> -       URL: http://www.linux-mag.com/2000-03/gear_01.html
> +       URL: http://www.linux-mag.com/id/452
>          Keywords: PCI, bus, bus-mastering.
>          Description: The title says it all.
>
> @@ -502,7 +499,7 @@
>
>        * Title: "A Linux vm README"
>          Author: Kanoj Sarcar.
> -       URL: http://reality.sgi.com/kanoj_engr/vm229.html
> +       URL: http://kos.enix.org/pub/linux-vmm.html
>          Keywords: virtual memory, mm, pgd, vma, page, page flags, page
>          cache, swap cache, kswapd.
>          Description: Telegraphic, short descriptions and definitions
> @@ -659,7 +656,7 @@
>
>        * Name: "Linux Kernel Source Reference"
>          Author: Thomas Graichen.
> -       URL: http://innominate.org/~graichen/projects/lksr/
> +       URL: http://marc.info/?l=linux-kernel&m=96446640102205&w=4
>          Keywords: CVS, web, cvsweb, browsing source code.
>          Description: Web interface to a CVS server with the kernel
>          sources. "Here you can have a look at any file of the Linux kernel
> @@ -682,7 +679,7 @@
>          produced during the week. Published every Thursday.
>
>        * Name: "Kernel Traffic"
> -       URL: http://kt.zork.net/kernel-traffic/
> +       URL: http://kt.earth.li/kernel-traffic/index.html
>          Keywords: linux-kernel mailing list, weekly kernel news.
>          Description: Weekly newsletter covering the most relevant
>          discussions of the linux-kernel mailing list.
> diff --git a/Documentation/ko_KR/HOWTO b/Documentation/ko_KR/HOWTO
> index 029fca9..2bf6d3f 100644
> --- a/Documentation/ko_KR/HOWTO
> +++ b/Documentation/ko_KR/HOWTO
> @@ -122,7 +122,7 @@ mtk.manpages@gmail.com의 메인테이너에게 보낼 것을 권장한다.
>
>       올바른 패치들을 만드는 법에 관한 훌륭한 다른 문서들이 있다.
>       "The Perfect Patch"
> -        http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
> +        http://userweb.kernel.org/~akpm/stuff/tpp.txt
>       "Linux kernel patch submission format"
>           http://linux.yyz.us/patch-format.html
>
> @@ -192,7 +192,7 @@ Documentation/DocBook/ 디� �� 리 내에서 만들어지며 PDF, Postscript, H
>
>   여러분이 어디서 시작해야 � 진 모르지만 커널 개발 커뮤니티에 참여�  수
>   있는 일들을 찾길 원한다면 리눅스 커널 Janitor 프로� �트를 살펴봐라.
> -         http://janitor.kernelnewbies.org/
> +    http://kernelnewbies.org/KernelJanitors
>   그곳은 시작하기에 훌륭한 장소이다. 그곳은 리눅스 커널 소스 트리내에
>   간단히 � �리되�  수� ��  수 있는 문� �들에 관하여 설명한다. 여러분은 이
>   프로� �트를 대표하는 개발자들과 일하면서 자� 의 패치를 리눅스 커널 트리에
> @@ -596,7 +596,7 @@ Pat이라는 이름을 가진 여자가 있을 수도 있는 것이다. 리눅
>
>   이것이 무엇인지 더 자세한 것을 알�  싶다면 다음 문서의 ChageLog 항을 봐라.
>      "The Perfect Patch"
> -    http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
> +    http://userweb.kernel.org/~akpm/stuff/tpp.txt
>
>
>
> @@ -610,7 +610,7 @@ Pat이라는 이름을 가진 여자가 있을 수도 있는 것이다. 리눅
>
>
>   ----------
> -"개발 프로세스"(http://linux.tar.gz/articles/2.6-development_process) 섹션을
> +"개발 프로세스"(http://lwn.net/Articles/94386/) 섹션을
>   작성하는데 있어 참� �  문서를 사용하도록 허락해준 Paolo Ciarrocchi에게
>   감사한다. 여러분들이 말해야 �  것과 말해서는 안되는 것의 목록 중 일부를 � �공해준
>   Randy Dunlap과 Gerrit Huizenga에게 감사한다. 또한 검� 와 의견 그리�
> diff --git a/Documentation/laptops/acer-wmi.txt b/Documentation/laptops/acer-wmi.txt
> index 0768fcc..4beafa6 100644
> --- a/Documentation/laptops/acer-wmi.txt
> +++ b/Documentation/laptops/acer-wmi.txt
> @@ -173,7 +173,7 @@ Credits
>   *******
>
>   Olaf Tauber, who did the real hard work when he developed acerhk
> -http://www.informatik.hu-berlin.de/~tauber/acerhk
> +http://www.cakey.de/acerhk/
>   All the authors of laptop ACPI modules in the kernel, whose work
>   was an inspiration in the early days of acer_acpi
>   Mathieu Segaud, who solved the problem with having to modprobe the driver
> diff --git a/Documentation/ldm.txt b/Documentation/ldm.txt
> index 718085b..4f80edd 100644
> --- a/Documentation/ldm.txt
> +++ b/Documentation/ldm.txt
> @@ -98,7 +98,7 @@ More Documentation
>   There is an Overview of the LDM together with complete Technical Documentation.
>   It is available for download.
>
> -  http://www.linux-ntfs.org/content/view/19/37/
> +  http://www.linux-ntfs.org/
>
>   If you have any LDM questions that aren't answered in the documentation, email
>   me.
> diff --git a/Documentation/md.txt b/Documentation/md.txt
> index e4e893e..a81c7b4 100644
> --- a/Documentation/md.txt
> +++ b/Documentation/md.txt
> @@ -1,5 +1,5 @@
>   Tools that manage md devices can be found at
> -   http://www.<country>.kernel.org/pub/linux/utils/raid/....
> +   http://www.kernel.org/pub/linux/utils/raid/
>
>
>   Boot time assembly of RAID arrays
> diff --git a/Documentation/misc-devices/c2port.txt b/Documentation/misc-devices/c2port.txt
> index d9bf93e..ea73444 100644
> --- a/Documentation/misc-devices/c2port.txt
> +++ b/Documentation/misc-devices/c2port.txt
> @@ -32,10 +32,10 @@ The C2 Interface main references are at (http://www.silabs.com)
>   Silicon Laboratories site], see:
>
>   - AN127: FLASH Programming via the C2 Interface at
> -http://www.silabs.com/public/documents/tpub_doc/anote/Microcontrollers/Small_Form_Factor/en/an127.pdf, and
> +http://www.silabs.com/Support Documents/TechnicalDocs/an127.pdf
>
>   - C2 Specification at
> -http://www.silabs.com/public/documents/tpub_doc/spec/Microcontrollers/en/C2spec.pdf,
> +http://www.silabs.com/pages/DownloadDoc.aspx?FILEURL=Support%20Documents/TechnicalDocs/an127.pdf&src=SearchResults
>
>   however it implements a two wire serial communication protocol (bit
>   banging) designed to enable in-system programming, debugging, and
> diff --git a/Documentation/mtd/nand_ecc.txt b/Documentation/mtd/nand_ecc.txt
> index 274821b..990efd7 100644
> --- a/Documentation/mtd/nand_ecc.txt
> +++ b/Documentation/mtd/nand_ecc.txt
> @@ -91,7 +91,7 @@ ECC 1   rp15  rp14  rp13  rp12  rp11  rp10  rp09  rp08
>   ECC 2   cp5   cp4   cp3   cp2   cp1   cp0      1     1
>
>   I detected after writing this that ST application note AN1823
> -(http://www.st.com/stonline/books/pdf/docs/10123.pdf) gives a much
> +(http://www.st.com/stonline/) gives a much
>   nicer picture.(but they use line parity as term where I use row parity)
>   Oh well, I'm graphically challenged, so suffer with me for a moment :-)
>   And I could not reuse the ST picture anyway for copyright reasons.
> diff --git a/Documentation/networking/3c509.txt b/Documentation/networking/3c509.txt
> index 3c45d5d..dcc9eaf 100644
> --- a/Documentation/networking/3c509.txt
> +++ b/Documentation/networking/3c509.txt
> @@ -31,7 +31,7 @@ models:
>   Large portions of this documentation were heavily borrowed from the guide
>   written the original author of the 3c509 driver, Donald Becker. The master
>   copy of that document, which contains notes on older versions of the driver,
> -currently resides on Scyld web server: http://www.scyld.com/network/3c509.html.
> +currently resides on Scyld web server: http://www.scyld.com/.
>
>
>   (1) Special Driver Features
> diff --git a/Documentation/networking/README.ipw2100 b/Documentation/networking/README.ipw2100
> index f3fcaa4..6f85e1d 100644
> --- a/Documentation/networking/README.ipw2100
> +++ b/Documentation/networking/README.ipw2100
> @@ -72,8 +72,7 @@ such, if you are interested in deploying or shipping a driver as part of
>   solution intended to be used for purposes other than development, please
>   obtain a tested driver from Intel Customer Support at:
>
> -http://support.intel.com/support/notebook/sb/CS-006408.htm
> -
> +http://www.intel.com/support/wireless/sb/CS-006408.htm
>
>   1. Introduction
>   -----------------------------------------------
> diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
> index 80c7285..c276490 100644
> --- a/Documentation/networking/README.ipw2200
> +++ b/Documentation/networking/README.ipw2200
> @@ -85,7 +85,7 @@ such, if you are interested in deploying or shipping a driver as part of
>   solution intended to be used for purposes other than development, please
>   obtain a tested driver from Intel Customer Support at:
>
> -http://support.intel.com/support/notebook/sb/CS-006408.htm
> +http://support.intel.com
>
>
>   1.   Introduction
> diff --git a/Documentation/networking/README.sb1000 b/Documentation/networking/README.sb1000
> index f82d425..f92c2aa 100644
> --- a/Documentation/networking/README.sb1000
> +++ b/Documentation/networking/README.sb1000
> @@ -27,8 +27,8 @@ cable modem easy.
>      in Franco's original source code distribution .tar.gz file.  Support for
>      the sb1000 driver can be found at:
>
> -      http://home.adelphia.net/~siglercm/sb1000.html
> -      http://linuxpower.cx/~cable/
> +      http://web.archive.org/web/*/http://home.adelphia.net/~siglercm/sb1000.html
> +      http://web.archive.org/web/*/http://linuxpower.cx/~cable/
>
>      along with these utilities.
>
> diff --git a/Documentation/networking/arcnet.txt b/Documentation/networking/arcnet.txt
> index 7960125..9ff5795 100644
> --- a/Documentation/networking/arcnet.txt
> +++ b/Documentation/networking/arcnet.txt
> @@ -68,7 +68,7 @@ REAL NAME" to listserv@tichy.ch.uj.edu.pl.  Then, to submit messages to the
>   list, mail to linux-arcnet@tichy.ch.uj.edu.pl.
>
>   There are archives of the mailing list at:
> -	http://tichy.ch.uj.edu.pl/lists/linux-arcnet
> +	http://epistolary.org/mailman/listinfo.cgi/arcnet
>
>   The people on linux-net@vger.kernel.org have also been known to be very
>   helpful, especially when we're talking about ALPHA Linux kernels that may or
> @@ -79,7 +79,7 @@ Other Drivers and Info
>   ----------------------
>
>   You can try my ARCNET page on the World Wide Web at:
> -	http://www.worldvisions.ca/~apenwarr/arcnet/
> +	http://www.qis.net/~jschmitz/arcnet/	
>
>   Also, SMC (one of the companies that makes ARCnet cards) has a WWW site you
>   might be interested in, which includes several drivers for various cards
> diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.txt
> index 61f516b..e0ec7cb 100644
> --- a/Documentation/networking/bonding.txt
> +++ b/Documentation/networking/bonding.txt
> @@ -2432,7 +2432,7 @@ be found at:
>   https://lists.sourceforge.net/lists/listinfo/bonding-devel
>
>   Donald Becker's Ethernet Drivers and diag programs may be found at :
> - - http://www.scyld.com/network/
> + - http://web.archive.org/web/*/http://www.scyld.com/network/
>
>   You will also find a lot of information regarding Ethernet, NWay, MII,
>   etc. at www.scyld.com.
> diff --git a/Documentation/networking/decnet.txt b/Documentation/networking/decnet.txt
> index d896895..e12a490 100644
> --- a/Documentation/networking/decnet.txt
> +++ b/Documentation/networking/decnet.txt
> @@ -4,7 +4,7 @@
>   1) Other documentation....
>
>      o Project Home Pages
> -       http://www.chygwyn.com/DECnet/                      - Kernel info
> +       http://www.chygwyn.com/                      	    - Kernel info
>          http://linux-decnet.sourceforge.net/                - Userland tools
>          http://www.sourceforge.net/projects/linux-decnet/   - Status page
>
> diff --git a/Documentation/networking/fore200e.txt b/Documentation/networking/fore200e.txt
> index b1f337f..6e0d2a9 100644
> --- a/Documentation/networking/fore200e.txt
> +++ b/Documentation/networking/fore200e.txt
> @@ -39,7 +39,7 @@ version. Alternative binary firmware images can be found somewhere on the
>   ForeThought CD-ROM supplied with your adapter by FORE Systems.
>
>   You can also get the latest firmware images from FORE Systems at
> -http://www.fore.com. Register TACTics Online and go to
> +http://en.wikipedia.org/wiki/FORE_Systems. Register TACTics Online and go to
>   the 'software updates' pages. The firmware binaries are part of
>   the various ForeThought software distributions.
>
> diff --git a/Documentation/networking/ipddp.txt b/Documentation/networking/ipddp.txt
> index 661a555..ba5c217 100644
> --- a/Documentation/networking/ipddp.txt
> +++ b/Documentation/networking/ipddp.txt
> @@ -36,11 +36,6 @@ AppleTalk-IP to IP decapsulation.
>   Basic instructions for user space tools
>   =======================================
>
> -To enable AppleTalk-IP decapsulation/encapsulation you will need the
> -proper tools. You can get the tools for decapsulation from
> -http://spacs1.spacs.k12.wi.us/~jschlst/index.html and for encapsulation
> -from http://www.maths.unm.edu/~bradford/ltpc.html
> -
>   I will briefly describe the operation of the tools, but you will
>   need to consult the supporting documentation for each set of tools.
>
> diff --git a/Documentation/networking/iphase.txt b/Documentation/networking/iphase.txt
> index 55eac4a..670b72f 100644
> --- a/Documentation/networking/iphase.txt
> +++ b/Documentation/networking/iphase.txt
> @@ -22,7 +22,7 @@ The features and limitations of this driver are as follows:
>       - All variants of Interphase ATM PCI (i)Chip adapter cards are supported,
>         including x575 (OC3, control memory 128K , 512K and packet memory 128K,
>         512K and 1M), x525 (UTP25) and x531 (DS3 and E3). See
> -      http://www.iphase.com/site/iphase-web/?epi_menuItemID=e196f04b4b3b40502f150882e21046a0
> +      http://www.iphase.com/
>         for details.
>       - Only x86 platforms are supported.
>       - SMP is supported.
> diff --git a/Documentation/networking/packet_mmap.txt b/Documentation/networking/packet_mmap.txt
> index 98f71a5..2a72262 100644
> --- a/Documentation/networking/packet_mmap.txt
> +++ b/Documentation/networking/packet_mmap.txt
> @@ -8,7 +8,7 @@ capture network traffic with utilities like tcpdump or any other that needs
>   raw access to network interface.
>
>   You can find the latest version of this document at:
> -    http://pusa.uv.es/~ulisses/packet_mmap/
> +    http://wiki.ipxwarzone.com/index.php5?title=Linux_packet_mmap
>
>   Howto can be found at:
>       http://wiki.gnu-log.net (packet_mmap)
> @@ -56,7 +56,7 @@ support for PACKET_MMAP, and also probably the libpcap included in your distribu
>
>   I'm aware of two implementations of PACKET_MMAP in libpcap:
>
> -    http://pusa.uv.es/~ulisses/packet_mmap/  (by Simon Patarin, based on libpcap 0.6.2)
> +    http://wiki.ipxwarzone.com/		     (by Simon Patarin, based on libpcap 0.6.2)
>       http://public.lanl.gov/cpw/              (by Phil Wood, based on lastest libpcap)
>
>   The rest of this document is intended for people who want to understand
> diff --git a/Documentation/networking/ray_cs.txt b/Documentation/networking/ray_cs.txt
> index 145d27a..c0c1230 100644
> --- a/Documentation/networking/ray_cs.txt
> +++ b/Documentation/networking/ray_cs.txt
> @@ -13,8 +13,8 @@ wireless LAN cards.
>
>   As of kernel 2.3.18, the ray_cs driver is part of the Linux kernel
>   source.  My web page for the development of ray_cs is at
> -http://world.std.com/~corey/raylink.html and I can be emailed at
> -corey@world.std.com
> +http://web.ralinktech.com/ralink/Home/Support/Linux.html
> +and I can be emailed at corey@world.std.com
>
>   The kernel driver is based on ray_cs-1.62.tgz
>
> diff --git a/Documentation/networking/s2io.txt b/Documentation/networking/s2io.txt
> index c3d6b4d..9d4e0f4 100644
> --- a/Documentation/networking/s2io.txt
> +++ b/Documentation/networking/s2io.txt
> @@ -133,7 +133,8 @@ bring down CPU utilization.
>   ** For AMD opteron platforms with 8131 chipset, MMRBC=1 and MOST=1 are
>   recommended as safe parameters.
>   For more information, please review the AMD8131 errata at
> -http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26310.pdf
> +http://vip.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/
> +26310_AMD-8131_HyperTransport_PCI-X_Tunnel_Revision_Guide_rev_3_18.pdf
>
>   6.  Available Downloads
>   Neterion "s2io" driver in Red Hat and Suse 2.6-based distributions is kept up
> diff --git a/Documentation/networking/tlan.txt b/Documentation/networking/tlan.txt
> index 7e6aa5b..34550df 100644
> --- a/Documentation/networking/tlan.txt
> +++ b/Documentation/networking/tlan.txt
> @@ -2,7 +2,7 @@
>   (C) 1998 James Banks
>   (C) 1999-2001 Torben Mathiasen<tmm@image.dk, torben.mathiasen@compaq.com>
>
> -For driver information/updates visit http://opensource.compaq.com
> +For driver information/updates visit http://www.compaq.com
>
>
>   TLAN driver for Linux, version 1.14a
> @@ -113,5 +113,5 @@ III.  Things to try if you have problems.
>
>   There is also a tlan mailing list which you can join by sending "subscribe tlan"
>   in the body of an email to majordomo@vuser.vu.union.edu.
> -There is also a tlan website at http://opensource.compaq.com
> +There is also a tlan website at http://www.compaq.com
>
> diff --git a/Documentation/networking/udplite.txt b/Documentation/networking/udplite.txt
> index 855d8da..d727a38 100644
> --- a/Documentation/networking/udplite.txt
> +++ b/Documentation/networking/udplite.txt
> @@ -11,11 +11,13 @@
>     This file briefly describes the existing kernel support and the socket API.
>     For in-depth information, you can consult:
>
> -   o The UDP-Lite Homepage: http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/
> +   o The UDP-Lite Homepage:
> +	http://web.archive.org/web/*/http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/
>          From here you can also download some example application source code.
>
>      o The UDP-Lite HOWTO on
> -       http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/files/UDP-Lite-HOWTO.txt
> +       http://web.archive.org/web/*/http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/
> +	files/UDP-Lite-HOWTO.txt
>
>      o The Wireshark UDP-Lite WiKi (with capture files):
>          http://wiki.wireshark.org/Lightweight_User_Datagram_Protocol
> @@ -26,12 +28,7 @@
>     I) APPLICATIONS
>
>     Several applications have been ported successfully to UDP-Lite. Ethereal
> -  (now called wireshark) has UDP-Litev4/v6 support by default. The tarball on
> -
> -   http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/files/udplite_linux.tar.gz
> -
> -  has source code for several v4/v6 client-server and network testing examples.
> -
> +  (now called wireshark) has UDP-Litev4/v6 support by default.
>     Porting applications to UDP-Lite is straightforward: only socket level and
>     IPPROTO need to be changed; senders additionally set the checksum coverage
>     length (default = header length = 8). Details are in the next section.
> diff --git a/Documentation/networking/wavelan.txt b/Documentation/networking/wavelan.txt
> index afa6e52..90e0ac4 100644
> --- a/Documentation/networking/wavelan.txt
> +++ b/Documentation/networking/wavelan.txt
> @@ -50,7 +50,8 @@ and a Lucent Modem, and NOT 802.11 compatible.
>   -----------------
>   	o Config :	Not yet in kernel
>   	o Location :	Pcmcia package 3.1.10+
> -	o on-line doc :	http://www.fasta.fh-dortmund.de/users/andy/wvlan/
> +	o on-line doc :
> +	http://web.archive.org/web/*/http://www.fasta.fh-dortmund.de/users/andy/wvlan/	
>
>   	This is the driver for the current generation of Wavelan IEEE,
>   which is 802.11 compatible. Depending on version, it is 2 Mb/s or 11
> diff --git a/Documentation/power/apm-acpi.txt b/Documentation/power/apm-acpi.txt
> index 1bd799d..6cc423d 100644
> --- a/Documentation/power/apm-acpi.txt
> +++ b/Documentation/power/apm-acpi.txt
> @@ -28,5 +28,5 @@ and be sure that they are started sometime in the system boot process.
>   Go ahead and start both.  If ACPI or APM is not available on your
>   system the associated daemon will exit gracefully.
>
> -  apmd:   http://worldvisions.ca/~apenwarr/apmd/
> +  apmd:   http://ftp.debian.org/pool/main/a/apmd/
>     acpid:  http://acpid.sf.net/
> diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
> index 1555001..ddd7817 100644
> --- a/Documentation/power/basic-pm-debugging.txt
> +++ b/Documentation/power/basic-pm-debugging.txt
> @@ -179,8 +179,7 @@ use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
>
>   To verify that the STR works, it is generally more convenient to use the s2ram
>   tool available from http://suspend.sf.net and documented at
> -http://en.opensuse.org/s2ram .  However, before doing that it is recommended to
> -carry out STR testing using the facility described in section 1.
> +http://en.opensuse.org/SDB:Suspend_to_RAM.
>
>   Namely, after writing "freezer", "devices", "platform", "processors", or "core"
>   into /sys/power/pm_test (available if the kernel is compiled with
> diff --git a/Documentation/power/video.txt b/Documentation/power/video.txt
> index 2b35849..3e6272b 100644
> --- a/Documentation/power/video.txt
> +++ b/Documentation/power/video.txt
> @@ -67,11 +67,11 @@ There are a few types of systems where video works after S3 resume:
>     POSTing bios works. Ole Rohne has patch to do just that at
>     http://dev.gentoo.org/~marineam/patch-radeonfb-2.6.11-rc2-mm2.
>
> -(8) on some systems, you can use the video_post utility mentioned here:
> -  http://bugzilla.kernel.org/show_bug.cgi?id=3670. Do echo 3>  /sys/power/state
> -&&  /usr/sbin/video_post - which will initialize the display in console mode.
> -  If  you are in X, you can switch to a virtual terminal and back to X using
> -  CTRL+ALT+F1 - CTRL+ALT+F7 to get the display working in graphical mode again.
> +(8) on some systems, you can use the video_post utility and or
> +  do echo 3>  /sys/power/state&&  /usr/sbin/video_post - which will
> +  initialize the display in console mode. If you are in X, you can switch
> +  to a virtual terminal and back to X using  CTRL+ALT+F1 - CTRL+ALT+F7 to get
> +  the display working in graphical mode again.
>
>   Now, if you pass acpi_sleep=something, and it does not work with your
>   bios, you'll get a hard crash during resume. Be careful. Also it is
> @@ -177,7 +177,7 @@ Mainboard	    Graphics card                 hack (or "how to do it")
>   Asus A7V8X	    nVidia RIVA TNT2 model 64	  s3_bios,s3_mode (4)
>
>
> -(*) from http://www.ubuntulinux.org/wiki/HoaryPMResults, not sure
> +(*) from https://wiki.ubuntu.com/HoaryPMResults, not sure
>       which options to use. If you know, please tell me.
>
>   (***) To be tested with a newer kernel.
> diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/powerpc/booting-without-of.txt
> index 46d2210..568fa08 100644
> --- a/Documentation/powerpc/booting-without-of.txt
> +++ b/Documentation/powerpc/booting-without-of.txt
> @@ -1048,7 +1048,7 @@ IV - "dtc", the device tree compiler
>
>
>   dtc source code can be found at
> -<http://ozlabs.org/~dgibson/dtc/dtc.tar.gz>
> +<http://git.jdl.com/gitweb/?p=dtc.git>
>
>   WARNING: This version is still in early development stage; the
>   resulting device-tree "blobs" have not yet been validated with the
> diff --git a/Documentation/s390/Debugging390.txt b/Documentation/s390/Debugging390.txt
> index 1eb576a..86f9f74 100644
> --- a/Documentation/s390/Debugging390.txt
> +++ b/Documentation/s390/Debugging390.txt
> @@ -2531,5 +2531,5 @@ Special Thanks
>   ==============
>   Special thanks to Neale Ferguson who maintains a much
>   prettier HTML version of this page at
> -http://penguinvm.princeton.edu/notes.html#Debug390
> +http://linuxvm.org/penguinvm/
>   Bob Grainger Stefan Bader&  others for reporting bugs
> diff --git a/Documentation/scsi/BusLogic.txt b/Documentation/scsi/BusLogic.txt
> index 98023ba..d7fbc94 100644
> --- a/Documentation/scsi/BusLogic.txt
> +++ b/Documentation/scsi/BusLogic.txt
> @@ -47,7 +47,7 @@ tune driver performance and error recovery to their particular needs.
>   The latest information on Linux support for BusLogic SCSI Host Adapters, as
>   well as the most recent release of this driver and the latest firmware for the
>   BT-948/958/958D, will always be available from my Linux Home Page at URL
> -"http://www.dandelion.com/Linux/".
> +"http://sourceforge.net/projects/dandelion/".
>
>   Bug reports should be sent via electronic mail to "lnz@dandelion.com".  Please
>   include with the bug report the complete configuration messages reported by the
> diff --git a/Documentation/scsi/ChangeLog.megaraid b/Documentation/scsi/ChangeLog.megaraid
> index 38e9e7c..5e07d32 100644
> --- a/Documentation/scsi/ChangeLog.megaraid
> +++ b/Documentation/scsi/ChangeLog.megaraid
> @@ -215,7 +215,7 @@ Older Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)
>
>   3.	Convert pci_module_init to pci_register_driver
>   	Convert from pci_module_init to pci_register_driver
> -	(from:http://kerneljanitors.org/TODO)
> +	(from:http://kernelnewbies.org/KernelJanitors/TODO)
>   		- Signed-off-by: Domen Puncer<domen@coderock.org>
>
>   4.	Use the pre defined DMA mask constants from dma-mapping.h
> diff --git a/Documentation/scsi/FlashPoint.txt b/Documentation/scsi/FlashPoint.txt
> index 1540a92..5b5f29c 100644
> --- a/Documentation/scsi/FlashPoint.txt
> +++ b/Documentation/scsi/FlashPoint.txt
> @@ -13,7 +13,7 @@ operating system support to its BusLogic brand of FlashPoint Ultra SCSI
>   host adapters.  All of BusLogic's other SCSI host adapters, including the
>   MultiMaster line, currently support the Linux operating system.  Linux
>   drivers and information will be available on October 15th at
> -http://www.dandelion.com/Linux/.
> +http://sourceforge.net/projects/dandelion/.
>
>   "Mylex is committed to supporting the Linux community," says Peter Shambora,
>   vice president of marketing for Mylex.  "We have supported Linux driver
> @@ -27,7 +27,7 @@ Linux is a freely-distributed implementation of UNIX for Intel x86, Sun
>   SPARC, SGI MIPS, Motorola 68k, Digital Alpha AXP and Motorola PowerPC
>   machines.  It supports a wide range of software, including the X Window
>   System, Emacs, and TCP/IP networking.  Further information is available at
> -http://www.linux.org and http://www.ssc.com/linux.
> +http://www.linux.org and http://www.ssc.com/.
>
>   FlashPoint Host Adapters
>
> diff --git a/Documentation/scsi/Mylex.txt b/Documentation/scsi/Mylex.txt
> index cdf6929..3797f3e 100644
> --- a/Documentation/scsi/Mylex.txt
> +++ b/Documentation/scsi/Mylex.txt
> @@ -2,4 +2,4 @@ Please see the file README.BusLogic for information about Linux support for
>   Mylex (formerly BusLogic) MultiMaster and FlashPoint SCSI Host Adapters.
>
>   The Mylex DAC960 PCI RAID Controllers are now supported.  Please consult
> -http://www.dandelion.com/Linux/ for further information on the DAC960 driver.
> +http://sourceforge.net/projects/dandelion for further information on the DAC960 driver.
> diff --git a/Documentation/scsi/NinjaSCSI.txt b/Documentation/scsi/NinjaSCSI.txt
> index 3229b64..ac8db8c 100644
> --- a/Documentation/scsi/NinjaSCSI.txt
> +++ b/Documentation/scsi/NinjaSCSI.txt
> @@ -3,8 +3,6 @@
>
>   1. Comment
>    This is Workbit corp.'s(http://www.workbit.co.jp/) NinjaSCSI-3
> -(http://www.workbit.co.jp/ts/z_nj3r.html) and NinjaSCSI-32Bi
> -(http://www.workbit.co.jp/ts/z_njsc32bi.html) PCMCIA card driver module
>   for Linux.
>
>   2. My Linux environment
> diff --git a/Documentation/scsi/aic79xx.txt b/Documentation/scsi/aic79xx.txt
> index c014ecc..16e054c 100644
> --- a/Documentation/scsi/aic79xx.txt
> +++ b/Documentation/scsi/aic79xx.txt
> @@ -447,7 +447,7 @@ The following information is available in this file:
>         http://www.adaptec.com/buy-cables/.
>
>      Europe
> -    - Visit our Web site at http://www.adaptec-europe.com/.
> +    - Visit our Web site at http://www.adaptec.com/en-US/_common/world_index.
>       - To speak with a Technical Support Specialist, call, or email,
>         * German:  +49 89 4366 5522, Monday-Friday, 9:00-17:00 CET,
>           http://ask-de.adaptec.com/.
> diff --git a/Documentation/scsi/aic7xxx.txt b/Documentation/scsi/aic7xxx.txt
> index b7e238c..18f8d19 100644
> --- a/Documentation/scsi/aic7xxx.txt
> +++ b/Documentation/scsi/aic7xxx.txt
> @@ -344,7 +344,7 @@ The following information is available in this file:
>         http://www.adaptec.com/buy-cables/.
>
>      Europe
> -    - Visit our Web site at http://www.adaptec-europe.com/.
> +    - Visit our Web site at http://www.adaptec.com/en-US/_common/world_index.
>       - To speak with a Technical Support Specialist, call, or email,
>         * German:  +49 89 4366 5522, Monday-Friday, 9:00-17:00 CET,
>           http://ask-de.adaptec.com/.
> diff --git a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
> index 3920f28..45d61ad 100644
> --- a/Documentation/scsi/ibmmca.txt
> +++ b/Documentation/scsi/ibmmca.txt
> @@ -1109,7 +1109,7 @@
>        Q: Where can I find the latest info about this driver?
>        A: See the file MAINTAINERS for the current WWW-address, which offers
>           updates, info and Q/A lists. At this file's origin, the webaddress
> -	was: http://www.uni-mainz.de/~langm000/linux.html
> +	was: http://www.staff.uni-mainz.de/mlang/linux.html
>        Q: My SCSI-adapter is not recognized by the driver, what can I do?
>        A: Just force it to be recognized by kernel parameters. See section 5.1.
>           If this really happens, do also send e-mail to the maintainer, as
> diff --git a/Documentation/scsi/osst.txt b/Documentation/scsi/osst.txt
> index 2b21890..ad86c6d 100644
> --- a/Documentation/scsi/osst.txt
> +++ b/Documentation/scsi/osst.txt
> @@ -135,7 +135,7 @@ The driver development is coordinated through a mailing list
>   a CVS repository and some web pages.
>   The tester's pages which contain recent news and updated drivers to download
>   can be found on
> -http://linux1.onstream.nl/test/
> +http://sourceforge.net/projects/osst/
>
>   If you find any problems, please have a look at the tester's page in order
>   to see whether the problem is already known and solved. Otherwise, please
> diff --git a/Documentation/scsi/ppa.txt b/Documentation/scsi/ppa.txt
> index 067ac39..05ff47d 100644
> --- a/Documentation/scsi/ppa.txt
> +++ b/Documentation/scsi/ppa.txt
> @@ -1,13 +1,13 @@
>   -------- Terse where to get ZIP Drive help info --------
>
>   General Iomega ZIP drive page for Linux:
> -http://www.torque.net/~campbell/
> +http://web.archive.org/web/*/http://www.torque.net/~campbell/
>
>   Driver archive for old drivers:
> -http://www.torque.net/~campbell/ppa/
> +http://web.archive.org/web/*/http://www.torque.net/~campbell/ppa
>
>   Linux Parport page (parallel port)
> -http://www.torque.net/parport/
> +http://web.archive.org/web/*/http://www.torque.net/parport/
>
>   Email list for Linux Parport
>   linux-parport@torque.net
> diff --git a/Documentation/scsi/scsi-generic.txt b/Documentation/scsi/scsi-generic.txt
> index c38e2b3..0a22ab8 100644
> --- a/Documentation/scsi/scsi-generic.txt
> +++ b/Documentation/scsi/scsi-generic.txt
> @@ -34,11 +34,11 @@ http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO
>   This describes the sg version 3 driver found in the lk 2.4 series.
>   The LDP renders documents in single and multiple page HTML, postscript
>   and pdf. This document can also be found at:
> -http://www.torque.net/sg/p/sg_v3_ho.html
> +http://sg.danny.cz/sg/p/sg_v3_ho.html
>
>   Documentation for the version 2 sg driver found in the lk 2.2 series can
> -be found at http://www.torque.net/sg/p/scsi-generic.txt . A larger version
> -is at:  http://www.torque.net/sg/p/scsi-generic_long.txt .
> +be found at http://sg.danny.cz/sg/. A larger version
> +is at: http://sg.danny.cz/sg/p/scsi-generic_long.txt.
>
>   The original documentation for the sg driver (prior to lk 2.2.6) can be
>   found at http://www.torque.net/sg/p/original/SCSI-Programming-HOWTO.txt
> @@ -61,7 +61,7 @@ There are two packages of sg utilities:
>     - sg_utils    for the sg version 2 (and original) driver found in lk 2.2
>                   and earlier
>   Both packages will work in the lk 2.4 series however sg3_utils offers more
> -capabilities. They can be found at: http://www.torque.net/sg and
> +capabilities. They can be found at: http://sg.danny.cz/sg/sg3_utils.html and
>   freshmeat.net
>
>   Another approach is to look at the applications that use the sg driver.
> diff --git a/Documentation/scsi/scsi.txt b/Documentation/scsi/scsi.txt
> index dd1bbf4..3d99d38 100644
> --- a/Documentation/scsi/scsi.txt
> +++ b/Documentation/scsi/scsi.txt
> @@ -4,8 +4,8 @@ The Linux Documentation Project (LDP) maintains a document describing
>   the SCSI subsystem in the Linux kernel (lk) 2.4 series. See:
>   http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO . The LDP has single
>   and multiple page HTML renderings as well as postscript and pdf.
> -It can also be found at http://www.torque.net/scsi/SCSI-2.4-HOWTO .
> -
> +It can also be found at:
> +http://web.archive.org/web/*/http://www.torque.net/scsi/SCSI-2.4-HOWTO
>
>   Notes on using modules in the SCSI subsystem
>   ============================================
> diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
> index de67229..570ef2b 100644
> --- a/Documentation/scsi/scsi_mid_low_api.txt
> +++ b/Documentation/scsi/scsi_mid_low_api.txt
> @@ -43,7 +43,7 @@ There is a SCSI documentation directory within the kernel source tree,
>   typically Documentation/scsi . Most documents are in plain
>   (i.e. ASCII) text. This file is named scsi_mid_low_api.txt and can be
>   found in that directory. A more recent copy of this document may be found
> -at http://www.torque.net/scsi/scsi_mid_low_api.txt.gz .
> +at http://web.archive.org/web/20070107183357rn_1/sg.torque.net/scsi/.
>   Many LLDs are documented there (e.g. aic7xxx.txt). The SCSI mid-level is
>   briefly described in scsi.txt which contains a url to a document
>   describing the SCSI subsystem in the lk 2.4 series. Two upper level
> diff --git a/Documentation/serial/moxa-smartio b/Documentation/serial/moxa-smartio
> index 5337e80..d104439 100644
> --- a/Documentation/serial/moxa-smartio
> +++ b/Documentation/serial/moxa-smartio
> @@ -76,7 +76,7 @@ Content
>      GNU General Public License in this version. Please refer to GNU General
>      Public License announcement in each source code file for more detail.
>
> -   In Moxa's Web sites, you may always find latest driver at http://web.moxa.com.
> +   In Moxa's Web sites, you may always find latest driver at http://www.moxa.com/.
>
>      This version of driver can be installed as Loadable Module (Module driver)
>      or built-in into kernel (Static driver). You may refer to following
> diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
> index 2075bbb..7f4dceb 100644
> --- a/Documentation/sound/alsa/ALSA-Configuration.txt
> +++ b/Documentation/sound/alsa/ALSA-Configuration.txt
> @@ -1285,7 +1285,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
>       about this driver.  Note that it has been discontinued, but the
>       Voyetra Turtle Beach knowledge base entry for it is still available
>       at
> -	http://www.turtlebeach.com/site/kb_ftp/790.asp
> +	http://www.turtlebeach.com
>
>     Module snd-msnd-pinnacle
>     ------------------------
> diff --git a/Documentation/sound/alsa/HD-Audio.txt b/Documentation/sound/alsa/HD-Audio.txt
> index bdafdbd..278cc21 100644
> --- a/Documentation/sound/alsa/HD-Audio.txt
> +++ b/Documentation/sound/alsa/HD-Audio.txt
> @@ -562,7 +562,7 @@ compare the codec registers directly.
>   Send a bug report either the followings:
>
>   kernel-bugzilla::
> -  http://bugme.linux-foundation.org/
> +  https://bugzilla.kernel.org/
>   alsa-devel ML::
>     alsa-devel@alsa-project.org
>
> diff --git a/Documentation/sound/alsa/soc/DAI.txt b/Documentation/sound/alsa/soc/DAI.txt
> index 0ebd7ea..c967926 100644
> --- a/Documentation/sound/alsa/soc/DAI.txt
> +++ b/Documentation/sound/alsa/soc/DAI.txt
> @@ -13,7 +13,7 @@ frame (FRAME) (usually 48kHz) is always driven by the controller. Each AC97
>   frame is 21uS long and is divided into 13 time slots.
>
>   The AC97 specification can be found at :-
> -http://www.intel.com/design/chipsets/audio/ac97_r23.pdf
> +http://www.intel.com/p/en_US/business/design
>
>
>   I2S
> diff --git a/Documentation/sound/alsa/soc/codec.txt b/Documentation/sound/alsa/soc/codec.txt
> index 1e95342..37ba3a7 100644
> --- a/Documentation/sound/alsa/soc/codec.txt
> +++ b/Documentation/sound/alsa/soc/codec.txt
> @@ -143,7 +143,7 @@ struct snd_soc_ops {
>   };
>
>   Please refer to the ALSA driver PCM documentation for details.
> -http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c436.htm
> +http://www.alsa-project.org/~iwai/writing-an-alsa-driver/
>
>
>   5 - DAPM description.
> diff --git a/Documentation/sound/alsa/soc/platform.txt b/Documentation/sound/alsa/soc/platform.txt
> index b681d17..06d8359 100644
> --- a/Documentation/sound/alsa/soc/platform.txt
> +++ b/Documentation/sound/alsa/soc/platform.txt
> @@ -39,7 +39,7 @@ struct snd_soc_platform {
>   };
>
>   Please refer to the ALSA driver documentation for details of audio DMA.
> -http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c436.htm
> +http://www.alsa-project.org/~iwai/writing-an-alsa-driver/
>
>   An example DMA driver is soc/pxa/pxa2xx-pcm.c
>
> diff --git a/Documentation/sound/oss/README.OSS b/Documentation/sound/oss/README.OSS
> index fd42b05..c615deb 100644
> --- a/Documentation/sound/oss/README.OSS
> +++ b/Documentation/sound/oss/README.OSS
> @@ -36,7 +36,7 @@ with OSS API.
>
>   Packages "snd-util-3.8.tar.gz" and "snd-data-0.1.tar.Z"
>   contain useful utilities to be used with this driver.
> -See http://www.opensound.com/ossfree/getting.html for
> +See http://www.opensound.com/ossfree/ for
>   download instructions.
>
>   If you are looking for the installation instructions, please
> @@ -1438,7 +1438,7 @@ of this driver (see http://www.4Front-tech.com/oss.html for more info).
>   There are some common audio chipsets that are not supported yet. For example
>   Sierra Aria and IBM Mwave. It's possible that these architectures
>   get some support in future but I can't make any promises. Just look
> -at the home page (http://www.opensound.com/ossfree/new_cards.html)
> +at the home page (http://www.opensound.com/ossfree/)
>   for latest info.
>
>   Information about unsupported sound cards and chipsets is welcome as well
> @@ -1449,7 +1449,6 @@ If you have any corrections and/or comments, please contact me.
>   Hannu Savolainen
>   hannu@opensound.com
>
> -Personal home page:	   http://www.compusonic.fi/~hannu
>   home page of OSS/Free: http://www.opensound.com/ossfree
>
>   home page of commercial OSS
> diff --git a/Documentation/telephony/ixj.txt b/Documentation/telephony/ixj.txt
> index 44d1240..4fb314d 100644
> --- a/Documentation/telephony/ixj.txt
> +++ b/Documentation/telephony/ixj.txt
> @@ -108,14 +108,9 @@ applications.
>
>   1.4  Where to get things
>
> -You can download the latest versions of the driver from:
> -
> -http://www.quicknet.net/develop.htm
> -
> -You can download the latest version of this document from:
> -
> -http://www.quicknet.net/develop.htm
> +Info on latest versions of the driver are here:
>
> +http://web.archive.org/web/*/http://www.quicknet.net/develop.htm
>
>   1.5  Mailing List
>
> diff --git a/Documentation/uml/UserModeLinux-HOWTO.txt b/Documentation/uml/UserModeLinux-HOWTO.txt
> index 628013f..7bde005 100644
> --- a/Documentation/uml/UserModeLinux-HOWTO.txt
> +++ b/Documentation/uml/UserModeLinux-HOWTO.txt
> @@ -8,62 +8,6 @@
>
>     Table of Contents
>
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
> -
>     1. Introduction
>
>        1.1 How is User Mode Linux Different?
> @@ -277,8 +221,7 @@
>
>     1. Download the latest UML patch from
>
> -     the download page<http://user-mode-linux.sourceforge.net/dl-
> -     sf.html>
> +     the download page<http://user-mode-linux.sourceforge.net/
>
>        In this example, the file is uml-patch-2.4.0-prerelease.bz2.
>
> @@ -438,7 +381,7 @@
>     as modules, especially filesystems and network protocols and filters,
>     so most symbols which need to be exported probably already are.
>     However, if you do find symbols that need exporting, let  us
> -<http://user-mode-linux.sourceforge.net/contacts.html>   know, and
> +<http://user-mode-linux.sourceforge.net/>   know, and
>     they'll be "taken care of".
>
>
> @@ -498,8 +441,8 @@
>
>     You will need a filesystem to boot UML from.  There are a number
>     available for download from  here<http://user-mode-
> -  linux.sourceforge.net/dl-sf.html>  .  There are also  several tools
> -<http://user-mode-linux.sourceforge.net/fs_making.html>   which can be
> +  linux.sourceforge.net/>  .  There are also  several tools
> +<http://user-mode-linux.sourceforge.net/>   which can be
>     used to generate UML-compatible filesystem images from media.
>     The kernel will boot up and present you with a login prompt.
>
> @@ -575,9 +518,9 @@
>
>     Here are some examples of UML in action:
>
> -  +o  A login session<http://user-mode-linux.sourceforge.net/login.html>
> +  +o  A login session<http://user-mode-linux.sourceforge.net/>
>
> -  +o  A virtual network<http://user-mode-linux.sourceforge.net/net.html>
> +  +o  A virtual network<http://user-mode-linux.sourceforge.net/>
>
>
>
> @@ -1236,7 +1179,7 @@
>
>
>     Harald's original README is here<http://user-mode-linux.source-
> -  forge.net/text/mcast.txt>   and explains these in detail, as well as
> +  forge.net/>   and explains these in detail, as well as
>     some other issues.
>
>
> @@ -1311,7 +1254,7 @@
>     kernel.
>
>     These were pointed out by Tim Robinson<timro at trkr dot net>  in
> -<http://www.geocrawler.com/lists/3/SourceForge/597/0/>  name="this uml-
> +<http://www.geocrawler.com/>  name="this uml-
>     user post">  .
>
>
> @@ -2038,7 +1981,7 @@
>
>     uml_moo is installed with the UML deb and RPM.  If you didn't install
>     UML from one of those packages, you can also get it from the UML
> -  utilities<http://user-mode-linux.sourceforge.net/dl-sf.html#UML
> +  utilities<http://user-mode-linux.sourceforge.net/
>     utilities>   tar file in tools/moo.
>
>
> @@ -3939,16 +3882,16 @@
>
>     This is a syslogd bug.  There's a race between a parent process
>     installing a signal handler and its child sending the signal.  See
> -  this uml-devel post<http://www.geocrawler.com/lists/3/Source-
> -  Forge/709/0/6612801>   for the details.
> +  this uml-devel post<http://www.geocrawler.com/>
> +  for the details.
>
>
>
>     1133..88..  TTUUNN//TTAAPP nneettwwoorrkkiinngg ddooeessnn''tt wwoorrkk oonn aa 22..44 hhoosstt
>
>     There are a couple of problems which were
> -<http://www.geocrawler.com/lists/3/SourceForge/597/0/>  name="pointed
> -  out">   by Tim Robinson<timro at trkr dot net>
> +<http://www.geocrawler.com>
> +  by Tim Robinson<timro at trkr dot net>
>
>     +o  It doesn't work on hosts running 2.4.7 (or thereabouts) or earlier.
>        The fix is to upgrade to something more recent and then read the
> @@ -4326,13 +4269,13 @@
>     Rusty Russell<rusty at linuxcare.com.au>   -
>
>     +o  wrote the  HOWTO<http://user-mode-
> -     linux.sourceforge.net/UserModeLinux-HOWTO.html>
> +     linux.sourceforge.net/>
>
>     +o  prodded me into making this project official and putting it on
>        SourceForge
>
>     +o  came up with the way cool UML logo<http://user-mode-
> -     linux.sourceforge.net/uml-small.png>
> +     linux.sourceforge.net/>
>
>     +o  redid the config process
>
> @@ -4599,7 +4542,7 @@
>
>     Michael Jennings<mikejen at hevanet.com>   sent in some material which
>     is now gracing the top of the  index  page<http://user-mode-
> -  linux.sourceforge.net/index.html>   of this site.
> +  linux.sourceforge.net/>   of this site.
>
>     SGI<http://www.sgi.com>   (and more specifically Ralf Baechle<ralf at
>     uni-koblenz.de>  ) gave me an account on oss.sgi.com
> diff --git a/Documentation/usb/linux.inf b/Documentation/usb/linux.inf
> index 2f7217d..af71d87 100644
> --- a/Documentation/usb/linux.inf
> +++ b/Documentation/usb/linux.inf
> @@ -9,7 +9,7 @@
>   ;
>   ; Microsoft only directly supports RNDIS drivers, and bundled them into XP.
>   ; The Microsoft "Remote NDIS USB Driver Kit" is currently found at:
> -;   http://www.microsoft.com/whdc/hwdev/resources/HWservices/rndis.mspx
> +;   http://www.microsoft.com/whdc/device/network/ndis/rmndis.mspx
>
>
>   [Version]
> diff --git a/Documentation/usb/mtouchusb.txt b/Documentation/usb/mtouchusb.txt
> index e43cfff..86302cd 100644
> --- a/Documentation/usb/mtouchusb.txt
> +++ b/Documentation/usb/mtouchusb.txt
> @@ -54,10 +54,6 @@ generic functions like calibrations, resets, and vendor information can be
>   requested from the userspace (And the drivers would handle the vendor specific
>   tasks).
>
> -ADDITIONAL INFORMATION/UPDATES/X CONFIGURATION EXAMPLE:
> -
> -http://groomlakelabs.com/grandamp/code/microtouch/
> -
>   TODO:
>
>   Implement a control urb again to handle requests to and from the device
> @@ -68,7 +64,7 @@ DISCLAIMER:
>   I am not a MicroTouch/3M employee, nor have I ever been.  3M does not support
>   this driver!  If you want touch drivers only supported within X, please go to:
>
> -http://www.3m.com/3MTouchSystems/downloads/
> +http://www.3m.com/3MTouchSystems/
>
>   THANKS:
>
> diff --git a/Documentation/usb/usb-serial.txt b/Documentation/usb/usb-serial.txt
> index f4d2145..5bd7926 100644
> --- a/Documentation/usb/usb-serial.txt
> +++ b/Documentation/usb/usb-serial.txt
> @@ -83,7 +83,7 @@ HandSpring Visor, Palm USB, and Clié USB driver
>     parameters.  e.g. modprobe visor vendor=0x54c product=0x66
>
>     There is a webpage and mailing lists for this portion of the driver at:
> -  http://usbvisor.sourceforge.net/
> +  http://sourceforge.net/projects/usbvisor/
>
>     For any questions or problems with this driver, please contact Greg
>     Kroah-Hartman at greg@kroah.com
> @@ -184,7 +184,7 @@ Keyspan USA-series Serial Adapters
>       functionality.
>
>     More information is available at:
> -        http://misc.nu/hugh/keyspan.html
> +        http://www.carnationsoftware.com/carnation/Keyspan.html
>
>     For any questions or problems with this driver, please contact Hugh
>     Blemings at hugh@misc.nu
> diff --git a/Documentation/video4linux/API.html b/Documentation/video4linux/API.html
> index d749d41..d72fd2a 100644
> --- a/Documentation/video4linux/API.html
> +++ b/Documentation/video4linux/API.html
> @@ -17,7 +17,7 @@
>      </tr>
>      <tr>
>       <td>
> -<a href="http://www.linuxtv.org/downloads/video4linux/API/V4L2_API">V4L2 API</a>
> +<a href="http://v4l2spec.bytesex.org/spec-single/v4l2.html">V4L2 API</a>
>       </td>
>       <td>Should be used for new projects
>       </td>
> diff --git a/Documentation/video4linux/CQcam.txt b/Documentation/video4linux/CQcam.txt
> index d230878..8977e7c 100644
> --- a/Documentation/video4linux/CQcam.txt
> +++ b/Documentation/video4linux/CQcam.txt
> @@ -203,11 +203,11 @@ The V4L2 API spec:
>     http://v4l2spec.bytesex.org/
>
>   Some web pages about the quickcams:
> -   http://www.dkfz-heidelberg.de/Macromol/wedemann/mini-HOWTO-cqcam.html
> +   http://www.pingouin-land.com/howto/QuickCam-HOWTO.html
>
>      http://www.crynwr.com/qcpc/            QuickCam Third-Party Drivers
>      http://www.crynwr.com/qcpc/re.html     Some Reverse Engineering
> -   http://cse.unl.edu/~cluening/gqcam/    v4l client
> +   http://www.wirelesscouch.net/software/gqcam/   v4l client
>      http://phobos.illtel.denver.co.us/pub/qcread/ doesn't use v4l
>      ftp://ftp.cs.unm.edu/pub/chris/quickcam/   Has lots of drivers
>      http://www.cs.duke.edu/~reynolds/quickcam/ Has lots of information
> diff --git a/Documentation/video4linux/README.cpia b/Documentation/video4linux/README.cpia
> index 19cd3bf..8a747fe 100644
> --- a/Documentation/video4linux/README.cpia
> +++ b/Documentation/video4linux/README.cpia
> @@ -185,7 +185,7 @@ THANKS (in no particular order):
>   ---------------------------------------------------------------------------
>   REFERENCES
>
> -   1. http://www.risc.uni-linz.ac.at/people/ppregler
> +   1. http://www.risc.uni-linz.ac.at/
>         mailto:Peter_Pregler@email.com
>      2. see the file COPYING in the top directory of the kernel tree
>      3. http://webcam.sourceforge.net/
> diff --git a/Documentation/video4linux/README.ivtv b/Documentation/video4linux/README.ivtv
> index 73df22c..42b0668 100644
> --- a/Documentation/video4linux/README.ivtv
> +++ b/Documentation/video4linux/README.ivtv
> @@ -10,7 +10,7 @@ Hauppauge PVR-350.
>   NOTE: this driver requires the latest encoder firmware (version 2.06.039, size
>   376836 bytes). Get the firmware from here:
>
> -http://dl.ivtvdriver.org/ivtv/firmware/firmware.tar.gz
> +http://dl.ivtvdriver.org/ivtv/firmware/
>
>   NOTE: 'normal' TV applications do not work with this driver, you need
>   an application that can handle MPEG input such as mplayer, xine, MythTV,
> diff --git a/Documentation/video4linux/Zoran b/Documentation/video4linux/Zoran
> index 0e89e76..00e3f92 100644
> --- a/Documentation/video4linux/Zoran
> +++ b/Documentation/video4linux/Zoran
> @@ -174,7 +174,7 @@ and is used in Argentinia, Uruguay, an a few others
>   We do not talk about how the audio is broadcast !
>
>   A rather good sites about the TV standards are:
> -http://www.sony.jp/ServiceArea/Voltage_map/
> +http://www.sony.jp/support/
>   http://info.electronicwerkstatt.de/bereiche/fernsehtechnik/frequenzen_und_normen/Fernsehnormen/
>   and http://www.cabl.com/restaurant/channel.html
>
> @@ -330,7 +330,7 @@ These extensions are known as the v4l/mjpeg extensions. See zoran.h for
>   details (structs/ioctls).
>
>   Information - video4linux:
> -http://roadrunner.swansea.linux.org.uk/v4lapi.shtml
> +http://linux.bytesex.org/v4l2/API.html
>   Documentation/video4linux/API.html
>   /usr/include/linux/videodev.h
>
> @@ -390,7 +390,7 @@ BUZIOC_G_STATUS
>   Get the status of the input lines (video source connected/norm).
>
>   For programming example, please, look at lavrec.c and lavplay.c code in
> -lavtools-1.2p2 package (URL: http://www.cicese.mx/~mirsev/DC10plus/)
> +lavtools-1.2p2 package (URL: http://www.cicese.mx/)
>   and the 'examples' directory in the original Buz driver distribution.
>
>   Additional notes for software developers:
> diff --git a/Documentation/video4linux/bttv/Cards b/Documentation/video4linux/bttv/Cards
> index d338965..12217fc 100644
> --- a/Documentation/video4linux/bttv/Cards
> +++ b/Documentation/video4linux/bttv/Cards
> @@ -802,7 +802,7 @@ Kworld (www.kworld.com.tw)
>
>
>
> -JTT/ Justy Corp.http://www.justy.co.jp/ (www.jtt.com.jp website down)
> +JTT/ Justy Corp.(http://www.jtt.ne.jp/)
>   ---------------------------------------------------------------------
>      JTT-02 (JTT TV) "TV watchmate pro" (bt848)
>
> @@ -828,7 +828,7 @@ Eline www.eline-net.com/
>      Eline Vision TVMaster / TVMaster FM (ELV-TVM/ ELV-TVM-FM) = LR26  (bt878)
>      Eline Vision TVMaster-2000 (ELV-TVM-2000, ELV-TVM-2000-FM)= LR138 (saa713x)
>
> -Spirit http://www.spiritmodems.com.au/
> +Spirit
>   ------
>      Spirit TV Tuner/Video Capture Card (bt848)
>
> @@ -959,6 +959,6 @@ Asus www.asuscom.com
>
>   Hoontech
>   --------
> -http://www.hoontech.com/korean/download/down_driver_list03.html
> +http://www.hoontech.de/
>      HART Vision 848 (H-ART Vision 848)
>      HART Vision 878 (H-Art Vision 878)
> diff --git a/Documentation/video4linux/bttv/MAKEDEV b/Documentation/video4linux/bttv/MAKEDEV
> index 6c29ba4..9d112f7 100644
> --- a/Documentation/video4linux/bttv/MAKEDEV
> +++ b/Documentation/video4linux/bttv/MAKEDEV
> @@ -14,7 +14,7 @@ function makedev () {
>   	ln -s /dev/${1}0 /dev/$1
>   }
>
> -# see http://roadrunner.swansea.uk.linux.org/v4lapi.shtml
> +# see http://linux.bytesex.org/v4l2/API.html
>
>   echo "*** new device names ***"
>   makedev video 0
> diff --git a/Documentation/video4linux/bttv/Specs b/Documentation/video4linux/bttv/Specs
> index 79b9e57..f32466c 100644
> --- a/Documentation/video4linux/bttv/Specs
> +++ b/Documentation/video4linux/bttv/Specs
> @@ -1,3 +1,3 @@
>   Philips		http://www.Semiconductors.COM/pip/
> -Conexant	http://www.conexant.com/techinfo/default.asp
> -Micronas	http://www.micronas.de/pages/product_documentation/index.html
> +Conexant	http://www.conexant.com/
> +Micronas	http://www.micronas.com/en/home/index.html
> diff --git a/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt b/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
> index faccee6..f4329a3 100644
> --- a/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
> +++ b/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
> @@ -44,7 +44,7 @@ http://www.atmel.com/dyn/resources/prod_documents/doc2817.pdf
>   This data sheet (google search) seems to have a lovely description of the
>   RC5 basics
>
> -http://users.pandora.be/nenya/electronics/rc5/  and more data
> +http://www.nenya.be/beor/electronics/rc5.htm  and more data
>
>   http://www.ee.washington.edu/circuit_archive/text/ir_decode.txt
>   and even a reference to how to decode a bi-phase data stream.
> diff --git a/Documentation/video4linux/hauppauge-wintv-cx88-ir.txt b/Documentation/video4linux/hauppauge-wintv-cx88-ir.txt
> index faccee6..a2fd363 100644
> --- a/Documentation/video4linux/hauppauge-wintv-cx88-ir.txt
> +++ b/Documentation/video4linux/hauppauge-wintv-cx88-ir.txt
> @@ -44,7 +44,7 @@ http://www.atmel.com/dyn/resources/prod_documents/doc2817.pdf
>   This data sheet (google search) seems to have a lovely description of the
>   RC5 basics
>
> -http://users.pandora.be/nenya/electronics/rc5/  and more data
> +http://www.nenya.be/beor/electronics/rc5.htm and more data
>
>   http://www.ee.washington.edu/circuit_archive/text/ir_decode.txt
>   and even a reference to how to decode a bi-phase data stream.
> diff --git a/Documentation/video4linux/ibmcam.txt b/Documentation/video4linux/ibmcam.txt
> index 397a94e..a510552 100644
> --- a/Documentation/video4linux/ibmcam.txt
> +++ b/Documentation/video4linux/ibmcam.txt
> @@ -27,9 +27,8 @@ SUPPORTED CAMERAS:
>
>   Xirlink "C-It" camera, also known as "IBM PC Camera".
>   The device uses proprietary ASIC (and compression method);
> -it is manufactured by Xirlink. See http://www.xirlink.com/
> -(renamed to http://www.veo.com), http://www.ibmpccamera.com,
> -or http://www.c-itnow.com/ for details and pictures.
> +it is manufactured by Xirlink. See http://xirlinkwebcam.sourceforge.net,
> +http://www.ibmpccamera.com, or http://www.c-itnow.com/ for details and pictures.
>
>   This very chipset ("X Chip", as marked at the factory)
>   is used in several other cameras, and they are supported
> diff --git a/Documentation/video4linux/se401.txt b/Documentation/video4linux/se401.txt
> index 7b9d1c9..bd6526e 100644
> --- a/Documentation/video4linux/se401.txt
> +++ b/Documentation/video4linux/se401.txt
> @@ -49,6 +49,6 @@ order to increase the throughput (and thus framerate).
>   HELP:
>
>   The latest info on this driver can be found at:
> -http://www.chello.nl/~j.vreeken/se401/
> +http://members.chello.nl/~j.vreeken/se401/
>   And questions to me can be send to:
>   pe1rxq@amsat.org
> diff --git a/Documentation/video4linux/w9966.txt b/Documentation/video4linux/w9966.txt
> index 78a6512..8550245 100644
> --- a/Documentation/video4linux/w9966.txt
> +++ b/Documentation/video4linux/w9966.txt
> @@ -24,7 +24,7 @@ where every two pixels take 4 bytes. In SDL (www.libsdl.org) this format
>   is called VIDEO_PALETTE_YUV422 (16 bpp).
>
>   A minimal test application (with source) is available from:
> -  http://hem.fyristorg.com/mogul/w9966.html
> +  http://www.slackwaresupport.com/howtos/Webcam-HOWTO
>
>   The slow framerate is due to missing DMA ECP read support in the
>   parport drivers. I might add working EPP support later.
> diff --git a/Documentation/w1/masters/ds2482 b/Documentation/w1/masters/ds2482
> index 299b91c..56f8eda 100644
> --- a/Documentation/w1/masters/ds2482
> +++ b/Documentation/w1/masters/ds2482
> @@ -6,8 +6,8 @@ Supported chips:
>       Prefix: 'ds2482'
>       Addresses scanned: None
>       Datasheets:
> -        http://pdfserv.maxim-ic.com/en/ds/DS2482-100-DS2482S-100.pdf
> -        http://pdfserv.maxim-ic.com/en/ds/DS2482-800-DS2482S-800.pdf
> +        http://datasheets.maxim-ic.com/en/ds/DS2482-100.pdf
> +        http://datasheets.maxim-ic.com/en/ds/DS2482-800.pdf
>
>   Author: Ben Gardner<bgardner@wabtec.com>
>
> diff --git a/Documentation/w1/masters/mxc-w1 b/Documentation/w1/masters/mxc-w1
> index 97f6199..38be1ad 100644
> --- a/Documentation/w1/masters/mxc-w1
> +++ b/Documentation/w1/masters/mxc-w1
> @@ -5,7 +5,8 @@ Supported chips:
>     * Freescale MX27, MX31 and probably other i.MX SoCs
>       Datasheets:
>           http://www.freescale.com/files/32bit/doc/data_sheet/MCIMX31.pdf?fpsp=1
> -	http://www.freescale.com/files/dsp/MCIMX27.pdf?fpsp=1
> +	http://cache.freescale.com/files/dsp/doc/archive/MCIMX27.pdf?fsrch=1&WT_TYPE=
> +	Data%20Sheets&WT_VENDOR=FREESCALE&WT_FILE_FORMAT=pdf&WT_ASSET=Documentation
>
>   Author: Originally based on Freescale code, prepared for mainline by
>   	Sascha Hauer<s.hauer@pengutronix.de>
> diff --git a/Documentation/w1/masters/omap-hdq b/Documentation/w1/masters/omap-hdq
> index ca722e0..884dc28 100644
> --- a/Documentation/w1/masters/omap-hdq
> +++ b/Documentation/w1/masters/omap-hdq
> @@ -7,7 +7,7 @@ Supported chips:
>
>   A useful link about HDQ basics:
>   ===============================
> -http://focus.ti.com/lit/an/slua408/slua408.pdf
> +http://focus.ti.com/lit/an/slua408a/slua408a.pdf
>
>   Description:
>   ============
> diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
> index 3d80e8a..05169e5 100644
> --- a/Documentation/zh_CN/HOWTO
> +++ b/Documentation/zh_CN/HOWTO
> @@ -112,7 +112,7 @@ Linux内� �代� �中包含有大量的文档。这些文档对于学� 如何与
>
>       其他关于如何正确地生成补丁的优秀文档包括：
>       "The Perfect Patch"
> -        http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
> +        http://userweb.kernel.org/~akpm/stuff/tpp.txt
>       "Linux kernel patch submission format"
>           http://linux.yyz.us/patch-format.html
>
> @@ -168,7 +168,7 @@ Linux内� �代� �中包含有大量的文档。这些文档对于学� 如何与
>
>   如果� 想� 入内� �开发社区并协助完成一些任务，却找不到从哪里开始，可以访问
>   “Linux内� �房管员”计划：
> -	http://janitor.kernelnewbies.org/
> +	http://kernelnewbies.org/KernelJanitors
>   这是极佳的起点。它提供一个相对简单的任务列表，列出内� �代� �中需要被重新
>   整理或者改正的地方。通过和负责这个计划的开发者们一同工作，� 会学到将补丁
>   集成进内� �的基本原理。如果还没有决定下一步要做什么的话，� 还可能会得到方
> @@ -515,7 +515,7 @@ Linux内� �社区并不喜欢一下接收大段的代� �。修改需要被恰当
>
>   想了解它具体应该看起来像什么，请查阅以下文档中的“ChangeLog”� 节：
>     “The Perfect Patch”
> -      http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
> +      http://userweb.kernel.org/~akpm/stuff/tpp.txt
>
>
>   这些事情有时候做起来很难。要在任何方面都做到完美可能需要好� 年时间。这是
> @@ -525,7 +525,7 @@ Linux内� �社区并不喜欢一下接收大段的代� �。修改需要被恰当
>
>   ---------------
>   感谢Paolo Ciarrocchi允许“开发流程”部分基于他所写的文�
> -(http://linux.tar.bz/articles/2.6-development_process)，感谢Randy
> +(http://www.kerneltravel.net/newbie/2.6-development_process)，感谢Randy
>   Dunlap和Gerrit Huizenga完善了应该说和不该说的列表。感谢Pat Mochel, Hanna
>   Linder, Randy Dunlap, Kay Sievers, Vojtech Pavlik, Jan Kara, Josh Boyer,
>   Kees Cook, Andrew Morton, Andi Kleen, Vadim Lobanov, Jesper Juhl, Adrian
> diff --git a/Documentation/zh_CN/SubmittingDrivers b/Documentation/zh_CN/SubmittingDrivers
> index 5f4815c..c27b0f6 100644
> --- a/Documentation/zh_CN/SubmittingDrivers
> +++ b/Documentation/zh_CN/SubmittingDrivers
> @@ -165,4 +165,4 @@ Linux USB项目：
>   	http://www.fenrus.org/how-to-not-write-a-device-driver-paper.pdf
>
>   内� �清洁工 (Kernel Janitor):
> -	http://janitor.kernelnewbies.org/
> +	http://kernelnewbies.org/KernelJanitors
> diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
> index 985c92e..9a1a6e1 100644
> --- a/Documentation/zh_CN/SubmittingPatches
> +++ b/Documentation/zh_CN/SubmittingPatches
> @@ -83,7 +83,7 @@ Quilt:
>   http://savannah.nongnu.org/projects/quilt
>
>   Andrew Morton 的补丁脚本:
> -http://www.zip.com.au/~akpm/linux/patches/
> +http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
>   作为这些脚本的替代，quilt 是值得推荐的补丁管理工具(看上面的链接)。
>
>   2)描述� 的改动。
> @@ -166,7 +166,7 @@ MAITAINERS 文件里的）发送一个手册页（man-pages）补丁，或者至
>     人拷贝，只要它是琐碎的）
>     任何文件的作者/维护者对该文件的改动（例如 patch monkey 在重� 模式下）
>
> -URL:<http://www.kernel.org/pub/linux/kernel/people/bunk/trivial/>
> +EMAIL: trivial@kernel.org
>
>   (译注，关于“琐碎补丁”的一些说明：� 为原文的这一部分写得比较简单，所以不得不
>   违例写一下译注。"trivial"这个英文单词的本意是“琐碎的，不重要的。”但是在这里
> @@ -394,7 +394,7 @@ Static inline 函数相比宏来说，是好得多的选择。Static inline 函
>   ----------------
>
>   Andrew Morton, "The perfect patch" (tpp).
> -<http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt>
> +<http://userweb.kernel.org/~akpm/stuff/tpp.txt>
>
>   Jeff Garzik, "Linux kernel patch submission format".
>     <http://linux.yyz.us/patch-format.html>

