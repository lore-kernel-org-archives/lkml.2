Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab1AVTnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 14:43:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42433 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab1AVTnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 14:43:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.38-rc2: acpi backlight control missing
Date: Sat, 22 Jan 2011 20:43:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@gver.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <1295693349.2120.3.camel@localhost.localdomain>
In-Reply-To: <1295693349.2120.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101222043.07703.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 22, 2011, Thomas Meyer wrote:
> with 2.6.38-rc2 the acpi backlight is gone:
> 
> $ ll /sys/devices/virtual/backlight 
> ls: cannot access /sys/devices/virtual/backlight: No such file or directory
> 
> $ ll /sys/class/backlight/
> total 0
> 
> with 2.6.37:
> $ ll /sys/devices/virtual/backlight
> insgesamt 0
> drwxr-xr-x. 3 root root 0 22. Jan 2011  acpi_video0
> 
> $ ll /sys/class/backlight/
> insgesamt 0
> lrwxrwxrwx. 1 root root 0 22. Jan 2011  acpi_video0
> -> ../../devices/virtual/backlight/acpi_video0
> 
> dmesg:
> 
> $ grep -i video dmesg-3*.txt
> dmesg-37.txt:[    0.216370] pci 0000:00:02.0: Boot video device
> dmesg-37.txt:[    1.102662] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
> dmesg-37.txt:[    1.102670] ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
> dmesg-37.txt:[   18.843946] Linux video capture interface: v2.00
> dmesg-37.txt:[   19.189825] uvcvideo: Found UVC 1.00 device WebCam (064e:a102)
> dmesg-37.txt:[   19.207062] usbcore: registered new interface driver uvcvideo
> dmesg-37.txt:[   19.207065] USB Video Class driver (v1.0.0)
> dmesg-38.txt:[    0.215527] pci 0000:00:02.0: Boot video device
> dmesg-38.txt:[   19.466882] Linux video capture interface: v2.00
> dmesg-38.txt:[   19.503083] uvcvideo: Found UVC 1.00 device WebCam (064e:a102)
> dmesg-38.txt:[   19.520292] usbcore: registered new interface driver uvcvideo
> dmesg-38.txt:[   19.520295] USB Video Class driver (v1.0.0)
> 
> $ grep ACPI_VIDEO /boot/config-2.6.3[78]*
> /boot/config-2.6.37:CONFIG_ACPI_VIDEO=y
> /boot/config-2.6.38-rc2:CONFIG_ACPI_VIDEO=y
> 
> any ideas?

Not really, but Matthew may have some (CCed).

Thanks,
Rafael
