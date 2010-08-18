Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0HRKUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 06:20:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34489 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0HRKUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 06:20:37 -0400
Date: Wed, 18 Aug 2010 11:20:33 +0100
From: Andy Whitcroft <apw@canonical.com>
To: "Gopinath, Thara" <thara@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch false positive in 2.6.36-rc1.
Message-ID: <20100818102033.GP6193@shadowen.org>
References: <5A47E75E594F054BAF48C5E4FC4B92AB0324222271@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0324222271@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 11:34:51AM +0530, Gopinath, Thara wrote:
> Hello Andy,
> 
> The following is my patch.
> 
> Index: linux-omap-pm/arch/arm/plat-omap/Kconfig
> ===================================================================
> --- linux-omap-pm.orig/arch/arm/plat-omap/Kconfig
> +++ linux-omap-pm/arch/arm/plat-omap/Kconfig
> @@ -37,7 +37,7 @@ config OMAP_DEBUG_LEDS
> 
>  config OMAP_SMARTREFLEX
>         bool "SmartReflex support"
> -       depends on ARCH_OMAP3 && PM
> +       depends on (ARCH_OMAP3 || ARCH_OMAP4) && PM
>         help
>           Say Y if you want to enable SmartReflex.
> 
> 
> And the following is the check patch error I am getting
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #108: FILE: arch/arm/plat-omap/Kconfig:41:
>         help
 
> total: 0 errors, 1 warnings, 67 lines checked

Yes that is a falsie.  I think I have fixed it in my tree.  Could you
test the version at the URL below and let me know if it works for you.

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
