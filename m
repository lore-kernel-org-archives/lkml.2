Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab2BPPeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:34:24 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:40676 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134Ab2BPPeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:34:23 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] arch/arm/mach-ks8695/leds.c: included linux/gpio.h twice
Date: Thu, 16 Feb 2012 16:33:24 +0100
User-Agent: KMail/1.9.10
Cc: "Simtec Linux Team" <linux@simtec.co.uk>,
        Daniel Silverstone <dsilvers@simtec.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1329403574-32717-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329403574-32717-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202161633.25223.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329406463;fe7365c3;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ignore this one since the fix is already in linux-next.

Danny

On Donnerstag, 16. Februar 2012, Danny Kukawka wrote:
> arch/arm/mach-ks8695/leds.c: included 'linux/gpio.h' twice,
> remove the duplicate.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  arch/arm/mach-ks8695/leds.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-ks8695/leds.c b/arch/arm/mach-ks8695/leds.c
> index d6f6502..4bd7075 100644
> --- a/arch/arm/mach-ks8695/leds.c
> +++ b/arch/arm/mach-ks8695/leds.c
> @@ -11,7 +11,6 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> -#include <linux/gpio.h>
>
>  #include <asm/leds.h>
>  #include <mach/devices.h>


