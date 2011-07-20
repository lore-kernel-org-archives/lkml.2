Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1GTMKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:10:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54778 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1GTMK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:10:28 -0400
Subject: Re: [patch]drivers:net:Kconfig
From: Eric Dumazet <eric.dumazet@gmail.com>
To: wangyanqing <udknight@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <20110720120500.GA3280@udknight.homenetwork>
References: <20110720120500.GA3280@udknight.homenetwork>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 14:10:19 +0200
Message-ID: <1311163819.2338.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 20 juillet 2011 à 20:05 +0800, wangyanqing a écrit :
> Broadcom Tigon3 driver tg3.ko can't work without the Broadcom PHY,
>  so maybe we should add a dependence on it.Or at least we should add
>  notice in the help txt.
> 
> Signed-off-by: wang yanqing <udknight@gmail.com>
> ---
>  drivers/net/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 93359fa..c2607cd 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2353,7 +2353,7 @@ config VIA_VELOCITY
>  
>  config TIGON3
>  	tristate "Broadcom Tigon3 support"
> -	depends on PCI
> +	depends on PCI && BROADCOM_PHY
>  	select PHYLIB
>  	help
>  	  This driver supports Broadcom Tigon3 based gigabit Ethernet cards.

Hmm.

When do you plan to answer to my previous question ?

I said :

Thats strange.

Here I have a (running) tg3 adapter, but

$ zgrep BROADCOM /proc/config.gz
# CONFIG_BROADCOM_PHY is not set

Could you elaborate ?



