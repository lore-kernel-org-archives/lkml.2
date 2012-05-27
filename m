Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2E0D0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 23:26:53 -0400
Received: from nm16.bullet.mail.bf1.yahoo.com ([98.139.212.175]:40281 "HELO
	nm16.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752134Ab2E0D0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 23:26:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 418230.6734.bm@omp1005.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:MIME-Version:Content-Type;
  b=5dT3KY+WADV1Zvo/+3A1ET8ic0dYazaNF5x4Ea4RPpr+xPHiMSBarsIocK+4ERa1TCSCtrsvLlmRNKgaPcgdvXwm8OB7T9DFcC5ij6aJh6U9K3U087cdm4PmQIRROy1fqCraamyqbZMlO951/GlG2kltIWlPHF1u/Fr6zBOcDuQ=;
X-YMail-OSG: Oi1tMI0VM1lBMsIu20UiTKSgCGA9jX5R7mRJcyXymDa6qye
 8WGsjQDRbszYnUIMUFIjRUHOMUTbXUvEyqBV5Sq7OZ4UW6D_My5KEEzFDuZH
 xHJxsiePQq5eMDtH4ctAv6wCtx0AgW0cq8Ibp2D9tf1Jgn7kHSlXxrEjz7ja
 0J7iQn6wMAA0Ggvi0PT_RAKJGMwwbdAai7C9s2pnzxv8bScYZ3lxckQFtuvF
 5KMIY2mXevhmAyPPVXFBSRwiQyuKucmHOZsXD8MJelhkE8QYe2niCtm3efmZ
 VmZQ90DPSennZ08bq4vRSP1riObDxRk.79bfc3PgW0_I4k8Fp4CeMNTONp_I
 R0ViJGDh0CkBYzUkVmjRgpMcrKi.LsW8I_UPwMXowFW00zhHd0kRrIPovmjW
 dwv_5eO08zUnce0EAY9xEy725a.9JGI_L12lDzKqQlsCXo7KZsnwDxyigdpM
 PLvzAwwXLqvLNV9ncpgMkrTzzUA--
X-Mailer: YahooMailClassic/15.0.6 YahooMailWebService/0.8.118.349524
Message-ID: <1338089209.85717.YahooMailClassic@web162605.mail.bf1.yahoo.com>
Date: Sat, 26 May 2012 20:26:49 -0700 (PDT)
From: Denis Lotarev <dlotarev@yahoo.com>
Subject: [BUG] Hibernate not working on laptop LENOVO X120e
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
My system on Lenovo X120e doesnt hibernate, when i trying to hibernate system power led begin often blinking (about 3 times at second), LCD turned off, HDD still working, and CPU fan workinkg too. There are no kernel log at messages, even if i run DEBUG=1 at pm-hibernate there are no errors at pm-hibernate.log. Suspent on RAM working good.
Linux lenarch 3.3.7-1-ARCH #1 SMP PREEMPT Mon May 21 22:39:59 UTC 2012 i686 GNU/Linux
 
Gnu C                  4.7.0
Gnu make               3.82
binutils               2.22.0.20120323
util-linux             2.21.1
mount                  support
module-init-tools      8
e2fsprogs              1.42.2
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.8
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      6.0.17
Procps                 3.3.2
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.17
wireless-tools         29
Modules Loaded         fuse aes_i586 cryptd aes_generic iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ip_tables x_tables rfcomm bnep uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev uas ums_realtek usb_storage btusb media bluetooth joydev cdc_acm cdc_ether usbnet cdc_wdm snd_hda_codec_conexant radeon i2c_algo_bit snd_hda_codec_hdmi thinkpad_acpi drm_kms_helper snd_hda_intel ttm snd_hda_codec drm agpgart i2c_piix4 r8169 snd_pcm snd_page_alloc snd_hwdep i2c_core nvram snd_timer serio_raw evdev arc4 snd k10temp mii psmouse soundcore button ac thermal video battery wmi brcmsmac cordic crc8 brcmutil bcma mac80211 cfg80211 rfkill powernow_k8 mperf processor ext4 crc16 jbd2 mbcache sd_mod ohci_hcd ahci libahci libata ehci_hcd usbcore scsi_mod usb_common
# lspci 
00:00.0 Host bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Complex
00:01.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Wrestler [Radeon HD 6310]
00:01.1 Audio device: Advanced Micro Devices [AMD] nee ATI Wrestler HDMI Audio [Radeon HD 6250/6310]
00:06.0 PCI bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Port
00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00 Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge (rev 40)
00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
00:15.1 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 0 (rev 43)
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 1
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 2
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 3
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 4
00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 6
00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 5
00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 7
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
04:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 003: ID 413c:8147 Dell Computer Corp. F3507g Mobile Broadband Module
Bus 002 Device 004: ID 064e:e201 Suyin Corp. Lenovo Integrated Webcam
Bus 004 Device 002: ID 0a5c:21b4 Broadcom Corp. BCM2070 Bluetooth 2.1 + EDR
Bus 003 Device 002: ID 0a5c:217f Broadcom Corp. Bluetooth Controller


Your sincerely, Denis Lotarev
