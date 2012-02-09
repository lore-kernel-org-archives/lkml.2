Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2BILGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 06:06:34 -0500
Received: from lebrac.rtp-net.org ([88.191.135.105]:58518 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2BILGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 06:06:33 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Feb 2012 06:06:33 EST
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Marc Kleine-Budde <mkl@blackshift.org>, Imre Kaloz <kaloz@openwrt.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/2] ARM: ixp4xx: fix compilation, add gpiolib support
Organization: RtpNet
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org>
	<1328729069-21308-2-git-send-email-mkl@blackshift.org>
	<20275.35898.120590.54388@pilspetsen.it.uu.se>
Date: Thu, 09 Feb 2012 11:57:17 +0100
In-Reply-To: <20275.35898.120590.54388@pilspetsen.it.uu.se> (Mikael
	Pettersson's message of "Thu, 9 Feb 2012 10:04:58 +0100")
Message-ID: <87fweki8aa.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson <mikpe@it.uu.se> writes:

> Marc Kleine-Budde writes:
>  > From: Imre Kaloz <kaloz@openwrt.org>
>  > 
>  > The problem was introduced with commit:
>  > "eb9ae7f gpio: fix build error in include/asm-generic/gpio.h"
>  > 
>  > This patch adds gpiolib support for the IXP4xx platform, which fixes the
>  > compilation of several ixp4xx platforms, e.g.:
>  > 
>  > In file included from arch/arm/mach-ixp4xx/include/mach/gpio.h:72,
>  >                  from /home/frogger/projects/server/linux/arch/arm/include/asm/gpio.h:9,
>  >                  from include/linux/gpio.h:30,
>  >                  from arch/arm/mach-ixp4xx/nslu2-setup.c:19:
>  > include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
>  > include/asm-generic/gpio.h:218: error: implicit declaration of function '__gpio_get_value'
>  > include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
>  > include/asm-generic/gpio.h:224: error: implicit declaration of function '__gpio_set_value'
>
> This fix is needed for 3.2 too, right?  I got the same errors when
> updating my (out-of-tree) ixp4xx/ds101 platform support to the 3.2 kernel
> a few days ago.

fwiw, it's even needed for 3.1. We've added it in the debian kernel when it
was sent to the linux-arm-kernel ml and it was for 3.1.

Arnaud
