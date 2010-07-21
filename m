Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab0GUEux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:50:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45814 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0GUEuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OeTA2/vrfwUqQVdlLOiVB12DTardRoG8+DQkzQClHXVTBjzDSx95GHa+5de82E/0JM
         Sqbjw5r46ly7IN3dCWQIYQ2xKY3buhQervVO+qyjV7O6YpACHYsdsfqSojC/qXX3f9HL
         EN5lP+wv/LMEdkqbZlrr0V4KtK4eQQ+YoZY30=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 000/139] update web addresses. 
Date: Tue, 20 Jul 2010 21:50:46 -0700
Message-Id: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I clearly have too much time on my hands.. 
Anyways I went through as much as possible and tried to update all the
web addresses that are broken in Documentation to the best as possible. 


Some addresses just had a change in name and ended up being a quick fix,
but other addresses ended up(maybe)removing the spec altogether form there
site. In this case I just put a direct link to the company itself
(if somebody finds the link please send me a post).

For the addresses that I could not find through searching, I ended up just 
removing altogether(some where as far back as 1995/99) if anybody knows
the location please let me know and/or send a fix so the kernel can be updated
as best as possible. 

In any case hope it's good if not I'll resend..main thing is I've located
the broken links that need updateing.



 Documentation/ABI/testing/sysfs-devices-memory     |    6 +-
 Documentation/ABI/testing/sysfs-devices-system-cpu |    2 +-
 Documentation/DocBook/scsi.tmpl                    |    2 +-
 Documentation/DocBook/v4l/compat.xml               |    5 +-
 Documentation/DocBook/v4l/fdl-appendix.xml         |    2 +-
 Documentation/HOWTO                                |    6 +-
 Documentation/RCU/RTFP.txt                         |    2 +-
 Documentation/SubmittingDrivers                    |    2 +-
 Documentation/aoe/aoe.txt                          |    2 +-
 Documentation/arm/IXP2000                          |    2 +-
 Documentation/arm/IXP4xx                           |   14 ++--
 Documentation/arm/README                           |    4 +-
 Documentation/arm/SA1100/Assabet                   |    5 +-
 Documentation/arm/SA1100/Brutus                    |    2 +-
 Documentation/arm/SA1100/FreeBird                  |    1 -
 Documentation/arm/SA1100/GraphicsClient            |    2 +-
 Documentation/arm/SA1100/GraphicsMaster            |    2 +-
 Documentation/arm/SA1100/Itsy                      |    2 +-
 Documentation/arm/SA1100/PLEB                      |    2 +-
 Documentation/arm/SA1100/Victor                    |    2 +-
 Documentation/arm/SA1100/nanoEngine                |    2 +-
 Documentation/binfmt_misc.txt                      |    2 +-
 Documentation/blockdev/paride.txt                  |    5 -
 Documentation/cdrom/packet-writing.txt             |   12 +---
 Documentation/cgroups/cpusets.txt                  |    2 +-
 Documentation/development-process/4.Coding         |    2 +-
 Documentation/device-mapper/dm-crypt.txt           |    2 +-
 Documentation/devices.txt                          |    8 +--
 Documentation/dvb/faq.txt                          |    2 +-
 Documentation/dvb/get_dvb_firmware                 |    4 +
 Documentation/fb/framebuffer.txt                   |    2 +-
 Documentation/filesystems/9p.txt                   |    2 +-
 Documentation/filesystems/affs.txt                 |    2 +-
 Documentation/filesystems/befs.txt                 |    4 +-
 Documentation/filesystems/isofs.txt                |    2 +-
 Documentation/filesystems/proc.txt                 |    4 +-
 Documentation/filesystems/vfat.txt                 |   10 --
 Documentation/hwmon/adm1026                        |    2 +-
 Documentation/hwmon/g760a                          |    2 +-
 Documentation/hwmon/gl518sm                        |    3 +-
 Documentation/hwmon/k8temp                         |    2 +-
 Documentation/hwmon/lm85                           |    4 +-
 Documentation/hwmon/smsc47m1                       |    8 +--
 Documentation/hwmon/thmc50                         |    2 +-
 Documentation/hwmon/via686a                        |    2 +-
 Documentation/hwmon/w83627hf                       |    6 +-
 Documentation/hwmon/w83781d                        |    2 +-
 Documentation/hwmon/w83792d                        |    2 +-
 Documentation/i2c/busses/i2c-ali1535               |    2 +-
 Documentation/i2c/busses/i2c-ali1563               |    2 +-
 Documentation/i2c/busses/i2c-ali15x3               |    2 +-
 Documentation/i2c/busses/i2c-piix4                 |    2 +-
 Documentation/i2c/busses/i2c-sis630                |    2 +-
 Documentation/ia64/aliasing.txt                    |    2 -
 Documentation/ia64/serial.txt                      |    2 +-
 Documentation/infiniband/user_verbs.txt            |    2 +-
 Documentation/input/appletouch.txt                 |    2 +-
 Documentation/input/bcm5974.txt                    |    2 +-
 Documentation/input/iforce-protocol.txt            |    2 +-
 Documentation/input/sentelic.txt                   |    2 +-
 Documentation/input/xpad.txt                       |    2 +-
 Documentation/intel_txt.txt                        |   11 +--
 Documentation/ioctl/ioctl-number.txt               |    9 +-
 Documentation/isdn/README                          |    2 +-
 Documentation/isdn/README.HiSax                    |    2 +-
 Documentation/ja_JP/HOWTO                          |    4 +-
 Documentation/ja_JP/SubmittingPatches              |    6 +-
 Documentation/kernel-docs.txt                      |   39 ++++-----
 Documentation/ko_KR/HOWTO                          |    8 +-
 Documentation/laptops/acer-wmi.txt                 |    2 +-
 Documentation/ldm.txt                              |    2 +-
 Documentation/md.txt                               |    2 +-
 Documentation/misc-devices/c2port.txt              |    4 +-
 Documentation/mtd/nand_ecc.txt                     |    2 +-
 Documentation/networking/3c509.txt                 |    2 +-
 Documentation/networking/README.ipw2100            |    2 +-
 Documentation/networking/README.ipw2200            |    2 +-
 Documentation/networking/README.sb1000             |    6 --
 Documentation/networking/arcnet.txt                |    4 +-
 Documentation/networking/bonding.txt               |    5 +-
 Documentation/networking/decnet.txt                |    2 +-
 Documentation/networking/fore200e.txt              |    2 +-
 Documentation/networking/ipddp.txt                 |    5 -
 Documentation/networking/iphase.txt                |    2 +-
 Documentation/networking/packet_mmap.txt           |    4 +-
 Documentation/networking/ray_cs.txt                |    4 +-
 Documentation/networking/s2io.txt                  |    2 +-
 Documentation/networking/tlan.txt                  |    4 +-
 Documentation/networking/udplite.txt               |    7 +--
 Documentation/networking/wavelan.txt               |    1 -
 Documentation/power/apm-acpi.txt                   |    2 +-
 Documentation/power/basic-pm-debugging.txt         |    3 +-
 Documentation/power/video.txt                      |   12 ++--
 Documentation/powerpc/booting-without-of.txt       |    2 +-
 Documentation/s390/Debugging390.txt                |    2 +-
 Documentation/scsi/BusLogic.txt                    |    2 +-
 Documentation/scsi/ChangeLog.megaraid              |    2 +-
 Documentation/scsi/FlashPoint.txt                  |    4 +-
 Documentation/scsi/Mylex.txt                       |    2 +-
 Documentation/scsi/NinjaSCSI.txt                   |    2 -
 Documentation/scsi/aic79xx.txt                     |    2 +-
 Documentation/scsi/aic7xxx.txt                     |    2 +-
 Documentation/scsi/ibmmca.txt                      |    2 +-
 Documentation/scsi/osst.txt                        |    2 +-
 Documentation/scsi/ppa.txt                         |    7 +-
 Documentation/scsi/scsi-generic.txt                |    8 +-
 Documentation/scsi/scsi.txt                        |    2 -
 Documentation/scsi/scsi_mid_low_api.txt            |    3 +-
 Documentation/serial/moxa-smartio                  |    2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt    |    2 +-
 Documentation/sound/alsa/HD-Audio.txt              |    2 +-
 Documentation/sound/alsa/soc/DAI.txt               |    2 +-
 Documentation/sound/alsa/soc/codec.txt             |    2 +-
 Documentation/sound/alsa/soc/platform.txt          |    2 +-
 Documentation/sound/oss/README.OSS                 |    5 +-
 Documentation/telephony/ixj.txt                    |   13 +--
 Documentation/uml/UserModeLinux-HOWTO.txt          |   89 ++++----------------
 Documentation/usb/linux.inf                        |    2 +-
 Documentation/usb/mtouchusb.txt                    |    6 +-
 Documentation/usb/usb-serial.txt                   |    4 +-
 Documentation/video4linux/API.html                 |    2 +-
 Documentation/video4linux/CQcam.txt                |    4 +-
 Documentation/video4linux/README.cpia              |    2 +-
 Documentation/video4linux/README.ivtv              |    2 +-
 Documentation/video4linux/Zoran                    |    6 +-
 Documentation/video4linux/bttv/Cards               |    6 +-
 Documentation/video4linux/bttv/MAKEDEV             |    2 +-
 Documentation/video4linux/bttv/Specs               |    4 +-
 .../video4linux/cx88/hauppauge-wintv-cx88-ir.txt   |    2 -
 .../video4linux/hauppauge-wintv-cx88-ir.txt        |    2 -
 Documentation/video4linux/ibmcam.txt               |    5 +-
 Documentation/video4linux/se401.txt                |    2 +-
 Documentation/video4linux/w9966.txt                |    2 +-
 Documentation/w1/masters/ds2482                    |    3 +-
 Documentation/w1/masters/mxc-w1                    |    2 +-
 Documentation/w1/masters/omap-hdq                  |    2 +-
 Documentation/zh_CN/HOWTO                          |    8 +-
 Documentation/zh_CN/SubmittingDrivers              |    2 +-
 Documentation/zh_CN/SubmittingPatches              |    6 +-
 139 files changed, 223 insertions(+), 375 deletions(-)

