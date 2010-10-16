Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0JPHs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:48:56 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:62381 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0JPHsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:48:55 -0400
Date: Sat, 16 Oct 2010 18:48:53 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, jkosina@suse.cz, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 2/2 v6]Update broken web addresses in the kernel.
In-Reply-To: <1287169117-7374-2-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.OSX.2.00.1010161759190.293@localhost>
References: <1287169117-7374-1-git-send-email-justinmattock@gmail.com> <1287169117-7374-2-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 15 Oct 2010, Justin P. Mattock wrote:

> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 280c9b5..32e67a1 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -73,8 +73,8 @@ config EFI_PCDP
>  	  on how the driver discovers devices.
>  
>  	  You must also enable the appropriate drivers (serial, VGA, etc.)
> -
> -	  See <http://www.dig64.org/specifications/DIG64_HCDPv20_042804.pdf>
> +	  See DIG64_HCDPv20_042804.pdf available from
> +	  <http://www.dig64.org/specifications/>

Why remove the blank line?


>  
>  config DELL_RBU
>  	tristate "BIOS update support for DELL systems via sysfs"

> diff --git a/drivers/firmware/pcdp.h b/drivers/firmware/pcdp.h
> index ce910d6..e098c6e 100644
> --- a/drivers/firmware/pcdp.h
> +++ b/drivers/firmware/pcdp.h
> @@ -1,8 +1,8 @@
>  /*
>   * Definitions for PCDP-defined console devices
>   *
> - * v1.0a: http://www.dig64.org/specifications/DIG64_HCDPv10a_01.pdf
> - * v2.0:  http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
> + * For DIG64_HCDPv10a_01.pdf and DIG64_PCDPv20.pdf (v10.a and v2.0 resp.),

v1.0a not v10.a


> + * please see <http://www.dig64.org/specifications/>
>   *
>   * (c) Copyright 2002, 2004 Hewlett-Packard Development Company, L.P.
>   *	Khalid Aziz <khalid.aziz@hp.com>

> diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
> index a6be529..87279d9 100644
> --- a/drivers/media/dvb/ttpci/av7110.c
> +++ b/drivers/media/dvb/ttpci/av7110.c
> @@ -2290,13 +2290,7 @@ static int frontend_init(struct av7110 *av7110)
>  /* Budgetpatch note:
>   * Original hardware design by Roberto Deza:
>   * There is a DVB_Wiki at
> - * http://212.227.36.83/linuxtv/wiki/index.php/Main_Page
> - * where is described this 'DVB TT Budget Patch', on Card Modding:
> - * http://212.227.36.83/linuxtv/wiki/index.php/DVB_TT_Budget_Patch
> - * On the short description there is also a link to a external file,
> - * with more details:
> - * http://perso.wanadoo.es/jesussolano/Ttf_tsc1.zip
> - *
> + * http://www.linuxtv.org/

Blank line needlessly removed?


>   * New software triggering design by Emard that works on
>   * original Roberto Deza's hardware:
>   *

>   *
>   * CHANGES:
> diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/radio-typhoon.c
> index 0343928..a5363ed 100644
> --- a/drivers/media/radio/radio-typhoon.c
> +++ b/drivers/media/radio/radio-typhoon.c
> @@ -1,8 +1,6 @@
>  /* Typhoon Radio Card driver for radio support
>   * (c) 1999 Dr. Henrik Seidel <Henrik.Seidel@gmx.de>
>   *
> - * Card manufacturer:
> - * http://194.18.155.92/idc/prod2.idc?nr=50753&lang=e
>   *

You should remove a blank line here to preserve the formatting.


>   * Notes on the hardware
>   *

> diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
> index c77bcc6..e225c00 100644
> --- a/drivers/video/hecubafb.c
> +++ b/drivers/video/hecubafb.c
> @@ -10,7 +10,7 @@
>   *
>   * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
>   * This work was possible because of apollo display code from E-Ink's website
> - * http://support.eink.com/community
> + * http://eink.com/

The old link is in the web archive, and the new one appears to have 
nothing relevant to apollo display code...


>   * All information used to write this code is from public material made
>   * available by E-Ink on its support site. Some commands such as 0xA4
>   * were found by looping through cmd=0x00 thru 0xFF and supplying random

Thanks.

Finn
