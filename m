Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2K3ISb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:18:31 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:54763 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab2K3ISa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:18:30 -0500
Message-ID: <50B86BCA.7050103@free-electrons.com>
Date: Fri, 30 Nov 2012 09:18:18 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@ni.com>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: sunxi: add missing include for mdelay()
References: <20121130013730.GA30592@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121130013730.GA30592@beefymiracle.amer.corp.natinst.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/11/2012 02:37, Josh Cartwright a écrit :
>   CC      arch/arm/mach-sunxi/sunxi.o
> ./arch/arm/mach-sunxi/sunxi.c: In function 'sunxi_restart':
> ./arch/arm/mach-sunxi/sunxi.c:55:3: error: implicit declaration of function 'mdelay' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

> ---
> Fixes multiplatform build error seen with today's linux-next-20121129.
> 
>  arch/arm/mach-sunxi/sunxi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> index dc634ae..9be910f 100644
> --- a/arch/arm/mach-sunxi/sunxi.c
> +++ b/arch/arm/mach-sunxi/sunxi.c
> @@ -10,6 +10,7 @@
>   * warranty of any kind, whether express or implied.
>   */
>  
> +#include <linux/delay.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/of_address.h>
> 


-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
