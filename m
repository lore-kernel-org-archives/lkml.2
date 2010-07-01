Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0GAE2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 00:28:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55482 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0GAE17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 00:27:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hu3npoepkAob59n2IpLjqtCePAbof3PFq4dNSRSH4lrpYQ5T3oEXuFzrT4TcGIW9Km
         cpy7wbjg4HEboQAg/eUlBgUVfTD2cyzKL0DUkHlVJr2E3e+oVlCsHHMNEPiUlwOP/Jvm
         Orsebg7fFSqH+VcA11GmJszb5Dqr/zuV1vjG4=
MIME-Version: 1.0
In-Reply-To: <e2a294ec1d41f1198f7ffae0e8bed2f67b41bbe8.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de> <e2a294ec1d41f1198f7ffae0e8bed2f67b41bbe8.1277911346.git.siccegge@cs.fau.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 1 Jul 2010 12:27:38 +0800
Message-ID: <AANLkTim9icxxarxlcC39tCnnAIwwBOF8l8a68nQy7xHQ@mail.gmail.com>
Subject: Re: [PATCH 24/33] Removing dead ARCH_GUMSTIX_ORIG
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de,
       Jaya Kumar <jayakumar.arm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 12:01 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
> ARCH_GUMSTIX_ORIG doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

Cc'ed Jaya Kumar for additional thoughts.

> ---
>  arch/arm/mach-pxa/include/mach/gumstix.h |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/include/mach/gumstix.h b/arch/arm/mach-pxa/include/mach/gumstix.h
> index 06abd41..9b89868 100644
> --- a/arch/arm/mach-pxa/include/mach/gumstix.h
> +++ b/arch/arm/mach-pxa/include/mach/gumstix.h
> @@ -14,25 +14,15 @@
>
>  /*
>  GPIOn - Input from MAX823 (or equiv), normalizing USB +5V into a clean
> -interrupt signal for determining cable presence. On the original gumstix,
> -this is GPIO81, and GPIO83 needs to be defined as well. On the gumstix F,
> +interrupt signal for determining cable presence. On the gumstix F,
>  this moves to GPIO17 and GPIO37. */
>
>  /* GPIOx - Connects to USB D+ and used as a pull-up after GPIOn
>  has detected a cable insertion; driven low otherwise. */
>
> -#ifdef CONFIG_ARCH_GUMSTIX_ORIG
> -
> -#define GPIO_GUMSTIX_USB_GPIOn         81
> -#define GPIO_GUMSTIX_USB_GPIOx         83
> -
> -#else
> -
>  #define GPIO_GUMSTIX_USB_GPIOn         35
>  #define GPIO_GUMSTIX_USB_GPIOx         41
>
> -#endif
> -
>  /* usb state change */
>  #define GUMSTIX_USB_INTR_IRQ           IRQ_GPIO(GPIO_GUMSTIX_USB_GPIOn)
>
> --
> 1.7.0.4
>
>
