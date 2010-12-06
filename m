Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0LFTjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 14:39:19 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22785 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab0LFTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 14:39:18 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/FkBPsS1y4DqSbGZPwhdJW
Date: Mon, 6 Dec 2010 11:39:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Hemanth V <hemanthv@ti.com>
Cc: linux-omap@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 2/2] omap4: platform changes for CMA3000
Message-ID: <20101206193913.GP8345@atomide.com>
References: <37166.10.24.255.17.1291028266.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37166.10.24.255.17.1291028266.squirrel@dbdmail.itg.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hemanth V <hemanthv@ti.com> [101129 02:48]:
> From 8082870cc704d901d98cf0d6af90e45860927ceb Mon Sep 17 00:00:00 2001
> From: Hemanth V <hemanthv@ti.com>
> Date: Thu, 26 Aug 2010 17:49:12 +0530
> Subject: [PATCH] Platform changes for CMA3000 Accelerometer driver
> 
> Update 4430 SDP board file with platform data for accelerometer driver
> and select the driver in kconfig
> 
> Signed-off-by: Hemanth V <hemanthv@ti.com>
> ---
>  arch/arm/mach-omap2/Kconfig         |    2 ++
>  arch/arm/mach-omap2/board-4430sdp.c |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index a928fd6..e87c049 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -255,6 +255,8 @@ config MACH_OMAP_4430SDP
>  	depends on ARCH_OMAP4
>  	select INPUT_TOUCHSCREEN
>  	select TOUCHSCREEN_SYNTM12XX
> +	select INPUT_MISC
> + 	select INPUT_CMA3000
> + 	select INPUT_CMA3000_I2C
> 

The better way is to patch omap2plus_defconfig so these get added
as modules.

Regards,

Tony
