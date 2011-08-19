Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1HSWNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:13:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53768 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab1HSWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:13:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] PM: Fix build due to missing notifier header
Date: Sat, 20 Aug 2011 00:15:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
References: <1313743385-8394-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1313743385-8394-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108200015.33262.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011, Mark Brown wrote:
> pm_clock.h uses a struct notifier_block without including notifier.h which
> appears to have caused it to fall victim to some of the current header
> reorganisations in -next. Fix the resulting build failures.

Thanks for the patch, but it should be fixed in the linux-pm tree
already.

Rafael


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
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

