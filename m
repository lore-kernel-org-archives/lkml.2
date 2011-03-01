Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1CAJQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:16:32 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:44033 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723Ab1CAJQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 04:16:30 -0500
Message-ID: <4D6CB9C4.8000609@metafoo.de>
Date: Tue, 01 Mar 2011 10:17:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Maurus Cuelenaere <mcuelenaere@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: Jz4740: Add HAVE_CLK
References: <4d6c2da3.cc7e0e0a.2116.ffffde18@mx.google.com>
In-Reply-To: <4d6c2da3.cc7e0e0a.2116.ffffde18@mx.google.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 12:20 AM, Maurus Cuelenaere wrote:
> Jz4740 supports the clock framework but doesn't have HAVE_CLK defined, so define
> it!
> 
> Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  arch/mips/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index f5ecc05..6199128 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -208,6 +208,7 @@ config MACH_JZ4740
>  	select ARCH_REQUIRE_GPIOLIB
>  	select SYS_HAS_EARLY_PRINTK
>  	select HAVE_PWM
> +	select HAVE_CLK
>  
>  config LASAT
>  	bool "LASAT Networks platforms"

