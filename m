Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab1IVULN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:11:13 -0400
Received: from relais.videotron.ca ([24.201.245.36]:30481 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1IVULJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:11:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 22 Sep 2011 16:10:35 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Axel Lin <axel.lin@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Don't include mach-nuc93x/Kconfig
In-reply-to: <1316721802-10852-1-git-send-email-swarren@nvidia.com>
Message-id: <alpine.LFD.2.00.1109221610060.12663@xanadu.home>
References: <1316721802-10852-1-git-send-email-swarren@nvidia.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Sep 2011, Stephen Warren wrote:

> Commit 6adc1e7ff19d9befdbb7781b26fff42bb0bc21e2 "ARM: mach-nuc93x: delete"
> removed support for this sub-architecture, thus deleting that file. So,
> don't include it. grep indicates no more references to this machine.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

This is fixed in the latest arm-soc.git.




> ---
>  arch/arm/Kconfig |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 89bd520..472a7f8 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -969,8 +969,6 @@ source "arch/arm/mach-netx/Kconfig"
>  source "arch/arm/mach-nomadik/Kconfig"
>  source "arch/arm/plat-nomadik/Kconfig"
>  
> -source "arch/arm/mach-nuc93x/Kconfig"
> -
>  source "arch/arm/plat-omap/Kconfig"
>  
>  source "arch/arm/mach-omap1/Kconfig"
> -- 
> 1.7.0.4
> 
