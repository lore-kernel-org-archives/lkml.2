Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2KMT4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:56:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:48430 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab2KMT4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:56:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,768,1352102400"; 
   d="scan'208";a="219138390"
Date: Tue, 13 Nov 2012 20:56:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 RESEND 0/4] mfd: tps65910: use regmap irq framework
 for interrupt
Message-ID: <20121113195637.GQ27828@sortiz-mobl>
References: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Tue, Nov 13, 2012 at 07:33:55PM +0530, Laxman Dewangan wrote:
> This patch series has following change:
> - Use regmap irq framework for interrupt registration. Corrected the
>   register bit definition for interrupts.
> - Move the irq table to tps65910.c and get rid of tps65910-irq.c.
> - Raarrange the init sequence of different sub moduled of tps65910 like
>   irq, clock and then mfd devices.
> - Export the irq domain handle from regmap to use in mfd driver.
> - Pass the irq domain in mfd_add_devices to have proper interrupt mapping
>   for sub devices like RTC.
> 
> 
> Changes from V1: 
> - rearrange patch on which older patch3 become the new patch 1.
> - Add stub for new api in the regmap.
> - Add empty line if paragraph change in description.
> 
> Changes from V2:
> - Remove the older 4th patch where API for getting irq_domain was added
>   in regmap. It is already taken care by Mark B.
The patchset looks fine, but it should either go through Mark's tree or I
should merge Mark's regmap_irq_get_domain patch to my for-next branch.
Mark, any preference ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
