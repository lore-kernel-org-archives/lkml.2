Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab2B0H1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:27:41 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:60054 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704Ab2B0H1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:27:40 -0500
Date: Mon, 27 Feb 2012 12:57:06 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>
Subject: Re: [PATCH] arch/arm/mach-ux500/board-mop500-u8500uib.c: included
 linux/gpio.h twice
Message-ID: <20120227072705.GA19429@bnru02>
References: <1329333578-31773-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329333578-31773-1-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 20:19:38 +0100, Danny Kukawka wrote:
> arch/arm/mach-ux500/board-mop500-u8500uib.c included 'linux/gpio.h'
> remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  arch/arm/mach-ux500/board-mop500-u8500uib.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/board-mop500-u8500uib.c b/arch/arm/mach-ux500/board-mop500-u8500uib.c
> index feb5744..ead91c9 100644
> --- a/arch/arm/mach-ux500/board-mop500-u8500uib.c
> +++ b/arch/arm/mach-ux500/board-mop500-u8500uib.c
> @@ -8,7 +8,6 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/i2c.h>
> -#include <linux/gpio.h>
>  #include <linux/interrupt.h>
>  #include <linux/mfd/tc3589x.h>
>  #include <linux/input/matrix_keypad.h>

Thanks,

Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>

Linus W, would you please pick if you have not noticed this.

srinidhi
