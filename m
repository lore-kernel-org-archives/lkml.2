Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2BPCev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:34:51 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36218 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab2BPCet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:34:49 -0500
MIME-Version: 1.0
In-Reply-To: <1329333565-31718-1-git-send-email-danny.kukawka@bisect.de>
References: <1329333565-31718-1-git-send-email-danny.kukawka@bisect.de>
Date: Thu, 16 Feb 2012 10:34:48 +0800
Message-ID: <CAN1soZyuqMHAsTU2Yjj=uxPREzqrTTxMpwgc3_wkvd6nVbfssw@mail.gmail.com>
Subject: Re: [PATCH] arch/arm/mach-pxa/pxa27x.c: included linux/gpio.h twice
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Eric Miao <eric.y.miao@gmail.com>, Danny Kukawka <dkukawka@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 3:19 AM, Danny Kukawka <danny.kukawka@bisect.de> wrote:
> arch/arm/mach-pxa/pxa27x.c included 'linux/gpio.h' twice, remove
> the duplicate.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  arch/arm/mach-pxa/pxa27x.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
> index aed6cbc..c1673b3 100644
> --- a/arch/arm/mach-pxa/pxa27x.c
> +++ b/arch/arm/mach-pxa/pxa27x.c
> @@ -22,7 +22,6 @@
>  #include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/i2c/pxa-i2c.h>
> -#include <linux/gpio.h>
>
>  #include <asm/mach/map.h>
>  #include <mach/hardware.h>
> --
> 1.7.8.3
>
Applied.

Thanks
Haojian
