Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1HSV6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:58:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab1HSV6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:58:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] PM: pm_clock.h needs to include linux/notifier.h
Date: Sat, 20 Aug 2011 00:00:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1313719486.20874.1.camel@phoenix>
In-Reply-To: <1313719486.20874.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108200000.24229.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011, Axel Lin wrote:
> This patch fixes below build error:

This problem should be fixed already in the linux-pm tree.

Thanks,
Rafael


>   CC      drivers/base/power/clock_ops.o
> In file included from drivers/base/power/clock_ops.c:13:
> include/linux/pm_clock.h:15: error: field 'nb' has incomplete type
> drivers/base/power/clock_ops.c: In function 'pm_clk_notify':
> drivers/base/power/clock_ops.c:437: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/base/power/clock_ops.c:437: warning: initialization from incompatible pointer type
> make[3]: *** [drivers/base/power/clock_ops.o] Error 1
> make[2]: *** [drivers/base/power] Error 2
> make[1]: *** [drivers/base] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against linux-next next-20110818.
> Axel
> 
>  include/linux/pm_clock.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pm_clock.h b/include/linux/pm_clock.h
> index f888013..8348866 100644
> --- a/include/linux/pm_clock.h
> +++ b/include/linux/pm_clock.h
> @@ -10,6 +10,7 @@
>  #define _LINUX_PM_CLOCK_H
>  
>  #include <linux/device.h>
> +#include <linux/notifier.h>
>  
>  struct pm_clk_notifier_block {
>  	struct notifier_block nb;
> 

