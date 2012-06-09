Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2FIANj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 20:13:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab2FIANh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 20:13:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: mathieu.poirier@linaro.org
Subject: Re: [PATCH 0/6] drivers: randconfig patches for kernel 3.5
Date: Sat, 9 Jun 2012 00:13:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        unsik Kim <donari75@gmail.com>
References: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206090013.27149.arnd@arndb.de>
X-Provags-ID: V02:K0:vfmqRqdEfgoj3dw1zuh4I3Vhq3iesjhcNdEMMDhkRjJ
 kNo76yVG1hJvQobX5+fF7zrqhGzsxIXBDzTBNNF+eHy+vAP8f+
 xWwJx8AQOmUOweYU6YDyqFPT85FpQq8slLQmv5UmH/ec6vsBeq
 uozvEjPeQdIo+qlGZ2E8zEqFfuMzZTdkmBPtlR2xDCax9l3EXy
 OUq1jH8AogQjs0zzg1Sb873NIbkND7D8AHDPpwN7LjEp2nvLgT
 AiGmuXrXBQv+pMkjrBB8huWuePvXrsRLacptyft4wweE++WUYQ
 ZhNU9HOY0jA6ekiDOhzCsonkKhal8vlRuIvDy0oBVqX7gpCAS0
 50+36EgRmTHBpokkqR8M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 June 2012, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> These patches fix miscellaneous problems when working
> with make randconfig.  They were discovered on kernel
> 3.1-rc4 and sent out during the 3.4 cycle but were not
> ack'ed.  
> 
> Sending out again for completeness.

Hi Mathieu,

I just realized that most of these are for the same subsystem
(framebuffer), so you should have kept the respective mailing list
and maintainer on Cc (added now). 

The mg_disk driver is not listed in the MAINTAINERS file but
has an author email listed in the file itself.

I can take the mg_disk patch into the arm-soc tree as a fix,
but I'd prefer the other patches to go through the framebuffer
tree.

	Arnd

> Arnd Bergmann (6):
>   drivers/video: use correct __devexit_p annotation
>   mg_disk: use readb/writeb instead of inb/outb
>   video/ili9320: do not mark exported functions __devexit
>   video/console: automatically select a font
>   drivers/savagefb: use mdelay instead of udelay
>   drivers/tosa: driver needs I2C and SPI to compile
> 
>  drivers/block/mg_disk.c                |   78 ++++++++++++++++----------------
>  drivers/video/backlight/Kconfig        |    2 +-
>  drivers/video/backlight/ili9320.c      |    2 +-
>  drivers/video/broadsheetfb.c           |    2 +-
>  drivers/video/console/Kconfig          |   14 ++++++
>  drivers/video/mbx/mbxfb.c              |    2 +-
>  drivers/video/savage/savagefb_driver.c |   10 ++--
>  7 files changed, 62 insertions(+), 48 deletions(-)
