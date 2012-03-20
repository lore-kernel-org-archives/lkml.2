Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2CTRqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 13:46:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58054 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab2CTRp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 13:45:59 -0400
MIME-Version: 1.0
In-Reply-To: <1331964860-25608-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <s5hwr6ksfm7.wl%tiwai@suse.de> <1331964860-25608-1-git-send-email-lucas.demarchi@profusion.mobi>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 20 Mar 2012 14:45:37 -0300
Message-ID: <CAMOw1v6oVQ2BM8JC4GxB3zm49Sn9AsDEtYZ7RVKF16e=PWLewQ@mail.gmail.com>
Subject: Re: [PATCHES v2 2/2] Remove references to /etc/modprobe.conf
To: rdunlap@xenotime.net, tiwai@suse.de
Cc: kay.sievers@vrfy.org, mchehab@infradead.org, perex@perex.cz, hjlipp@web.de,
        davem@davemloft.net, w.sang@pengutronix.de,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 3:14 AM, Lucas De Marchi
<lucas.demarchi@profusion.mobi> wrote:
> Usage of /etc/modprobe.conf file was deprecated by module-init-tools and
> is no longer parsed by new kmod tool. References to this file are
> replaced in Documentation, comments and Kconfig according to the
> context.
>
> There are also some references to the old /etc/modules.conf from 2.4
> kernels that are being removed.
>
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> ---
>  Documentation/aoe/aoe.txt                       |    2 +-
>  Documentation/aoe/autoload.sh                   |    4 +--
>  Documentation/blockdev/floppy.txt               |    2 +-
>  Documentation/fb/intel810.txt                   |    2 +-
>  Documentation/fb/intelfb.txt                    |    2 +-
>  Documentation/i2c/busses/scx200_acb             |    2 +-
>  Documentation/ide/ide.txt                       |    2 +-
>  Documentation/isdn/README.gigaset               |   16 ++++-----
>  Documentation/laptops/sonypi.txt                |    2 +-
>  Documentation/mono.txt                          |    8 ++---
>  Documentation/networking/baycom.txt             |    2 +-
>  Documentation/networking/bonding.txt            |   43 ++++++++++-------------
>  Documentation/networking/dl2k.txt               |   11 +++---
>  Documentation/networking/e100.txt               |    6 ++--
>  Documentation/networking/ipv6.txt               |    6 ++--
>  Documentation/networking/ixgb.txt               |    6 ++--
>  Documentation/networking/ltpc.txt               |    2 +-
>  Documentation/networking/vortex.txt             |    6 ++--
>  Documentation/parport.txt                       |   13 ++++---
>  Documentation/s390/3270.txt                     |   21 ++++++-----
>  Documentation/scsi/aic79xx.txt                  |    2 +-
>  Documentation/scsi/aic7xxx.txt                  |    2 +-
>  Documentation/scsi/osst.txt                     |    2 +-
>  Documentation/serial/computone.txt              |    8 ++---
>  Documentation/serial/rocket.txt                 |    2 +-
>  Documentation/serial/stallion.txt               |    4 +--
>  Documentation/sound/alsa/ALSA-Configuration.txt |   10 +++---
>  Documentation/sound/alsa/Audiophile-Usb.txt     |    4 +--
>  Documentation/sound/alsa/MIXART.txt             |    6 ++--
>  Documentation/sound/alsa/OSS-Emulation.txt      |    2 +-
>  Documentation/sound/oss/AudioExcelDSP16         |    6 ++--
>  Documentation/sound/oss/CMI8330                 |    5 ++-
>  Documentation/sound/oss/Introduction            |   10 +++---
>  Documentation/sound/oss/Opti                    |    8 ++---
>  Documentation/sound/oss/PAS16                   |    4 +--
>  Documentation/sound/oss/README.modules          |    8 ++---
>  Documentation/usb/power-management.txt          |    3 +-
>  Documentation/video4linux/CQcam.txt             |   14 ++------
>  Documentation/video4linux/Zoran                 |    2 +-
>  Documentation/video4linux/bttv/Modules.conf     |    2 +-
>  Documentation/video4linux/meye.txt              |    2 +-
>  drivers/net/wan/Kconfig                         |    4 +--
>  drivers/scsi/aic7xxx/aic79xx_osm.c              |    8 ++---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c              |    8 ++---
>  drivers/staging/asus_oled/README                |    2 +-
>  drivers/tty/isicom.c                            |    2 +-
>  drivers/usb/serial/ftdi_sio.c                   |    3 +-
>  drivers/usb/storage/Kconfig                     |    2 +-
>  sound/core/seq/seq_dummy.c                      |    2 +-
>  sound/drivers/Kconfig                           |    3 +-
>  50 files changed, 138 insertions(+), 160 deletions(-)

I'm not sure who would take this patch. Changes are mostly in Documentation.

Randy, could you take this? Or do you want this patch to be split and
go through each subsystem maintainer?

Takahashi, any objections on the new version?


Lucas De Marchi
