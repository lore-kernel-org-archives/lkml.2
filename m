Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab0GQOAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 10:00:12 -0400
Received: from promwad.com ([109.123.95.251]:39710 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab0GQOAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 10:00:09 -0400
X-Greylist: delayed 5122 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jul 2010 10:00:09 EDT
Message-ID: <4C41A413.50205@promwad.com>
Date: Sat, 17 Jul 2010 15:37:39 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
Reply-To: ivan.kuten@promwad.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: Linus Walleij <triad@df.lth.se>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, mattia.jona@gmail.com,
        "'Viktar Palstsiuk'" <viktar.palstsiuk@promwad.com>
Subject: Re: [PATCH 1/2] MISC: driver for the character LCD found in ARM refdesigns
References: <1279365780-18462-1-git-send-email-triad@df.lth.se>
In-Reply-To: <1279365780-18462-1-git-send-email-triad@df.lth.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

> diff --git a/drivers/misc/arm-charlcd.c b/drivers/misc/arm-charlcd.c
> new file mode 100644
> index 0000000..9e3879e
> --- /dev/null
> +++ b/drivers/misc/arm-charlcd.c
> @@ -0,0 +1,396 @@
> +/*
> + * Driver for the on-board character LCD found on some ARM reference boards
> + * This is basically an Hitachi HD44780 LCD with a custom IP block to drive it
> + * http://en.wikipedia.org/wiki/HD44780_Character_LCD
> + * Currently it will just display the text "ARM Linux" and the linux version
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + * Author: Linus Walleij<triad@df.lth.se>
> + */

Any chance to sync your efforts with lcd-linux project (http://lcd-linux.sourceforge.net/) ?
They seems to have a support for HD44780 LCD controller. Mattia, project maintainer is on CC 
copy.

Best regards,
Ivan Kuten
-----------------------------------------------------------
Head of Embedded Software Department

Promwad Innovation Company

22, Olshevskogo St.,

220073, Minsk,

BELARUS

Phone/Fax: +375 (17) 312-1246

Skype: vanokuten

Web: www.promwad.com









