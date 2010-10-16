Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0JPHs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:48:27 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:62372 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0JPHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:48:26 -0400
Date: Sat, 16 Oct 2010 18:48:17 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: trivial@kernel.org, jkosina@suse.cz, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/2 v6]Update broken web addresses in arch directory.
In-Reply-To: <1287169117-7374-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.OSX.2.00.1010161759140.293@localhost>
References: <1287169117-7374-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-379565301-1287212355=:293"
Content-ID: <alpine.OSX.2.00.1010161828200.293@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-379565301-1287212355=:293
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.OSX.2.00.1010161828201.293@localhost>


On Fri, 15 Oct 2010, Justin P. Mattock wrote:

> index 3499fad..0fd6a08 100644
> --- a/arch/arm/mach-pxa/am200epd.c
> +++ b/arch/arm/mach-pxa/am200epd.c
> @@ -10,7 +10,7 @@
>   * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoev=
en.
>   *
>   * This work was made possible by help and equipment support from E-Ink
> - * Corporation. http://support.eink.com/community
> + * Corporation. http://www.support.eink.com/

These are both dead links now. The old one is is in the web archive=20
anyway.


>   *
>   * This driver is written to be used with the Metronome display controll=
er.
>   * on the AM200 EPD prototype kit/development kit with an E-Ink 800x600
> diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
> index 993d75e..01aa021 100644
> --- a/arch/arm/mach-pxa/am300epd.c
> +++ b/arch/arm/mach-pxa/am300epd.c
> @@ -8,7 +8,7 @@
>   * more details.
>   *
>   * This work was made possible by help and equipment support from E-Ink
> - * Corporation. http://support.eink.com/community
> + * Corporation. http://www.support.eink.com/

Same here.


>   *
>   * This driver is written to be used with the Broadsheet display control=
ler.
>   * on the AM300 EPD prototype kit/development kit with an E-Ink 800x600

> diff --git a/arch/powerpc/include/asm/hydra.h b/arch/powerpc/include/asm/=
hydra.h
> index 1ad4eed..d529a2c 100644
> --- a/arch/powerpc/include/asm/hydra.h
> +++ b/arch/powerpc/include/asm/hydra.h
> @@ -10,7 +10,7 @@
>   *
>   *=09=A9 Copyright 1995 Apple Computer, Inc. All rights reserved.
>   *
> - *  It's available online from http://chrp.apple.com/MacTech.pdf.
> + *  It's available online from http://www.cpu.lu/~mlan/ftp/MacTech.pdf.

You should remove the trailing "." or else insert angle brackets.


>   *  You can obtain paper copies of this book from computer bookstores or=
 by
>   *  writing Morgan Kaufmann Publishers, Inc., 340 Pine Street, Sixth Flo=
or, San
>   *  Francisco, CA 94104. Reference ISBN 1-55860-393-X.


Thanks.

Finn
--0-379565301-1287212355=:293--
