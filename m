Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2KTJxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:53:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56933 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab2KTJxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:53:06 -0500
Message-ID: <50AB52F7.9000301@ti.com>
Date: Tue, 20 Nov 2012 10:52:55 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Constantine Shulyupin <const@MakeLinux.com>
CC: <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix compilation error in cm_common.c
References: <1353403553-13525-1-git-send-email-const@MakeLinux.com>
In-Reply-To: <1353403553-13525-1-git-send-email-const@MakeLinux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 10:25 AM, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Added required linux/errno.h
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>

This supposed to be already fixed:
https://patchwork.kernel.org/patch/1728521/

> ---
>  arch/arm/mach-omap2/cm_common.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-omap2/cm_common.c b/arch/arm/mach-omap2/cm_common.c
> index 3246cef..3fafc27 100644
> --- a/arch/arm/mach-omap2/cm_common.c
> +++ b/arch/arm/mach-omap2/cm_common.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> +#include <linux/errno.h>
>  
>  #include "cm2xxx.h"
>  #include "cm3xxx.h"
> 


-- 
Péter
