Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2IPXQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 19:16:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:35296 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab2IPXQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 19:16:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,432,1344236400"; 
   d="scan'208";a="193427521"
Date: Mon, 17 Sep 2012 01:16:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4] mfd: add MAX8907 core driver
Message-ID: <20120916231608.GM3647@sortiz-mobl>
References: <1345048126-24054-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345048126-24054-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Aug 15, 2012 at 10:28:46AM -0600, Stephen Warren wrote:
> From: Gyungoh Yoo <jack.yoo@maxim-ic.com>
> 
> The MAX8907 is an I2C-based power-management IC containing voltage
> regulators, a reset controller, a real-time clock, and a touch-screen
> controller.
> 
> The original driver was written by:
> * Gyungoh Yoo <jack.yoo@maxim-ic.com>
> 
> Various fixes and enhancements by:
> * Jin Park <jinyoungp@nvidia.com>
> * Tom Cherry <tcherry@nvidia.com>
> * Prashant Gaikwad <pgaikwad@nvidia.com>
> * Dan Willemsen <dwillemsen@nvidia.com>
> * Laxman Dewangan <ldewangan@nvidia.com>
> 
> During upstreaming, I (swarren):
> * Converted to regmap.
> * Converted to regmap-irq.
> * Allowed probing from device tree.
> * Renamed from max8907c->max8907, since the driver covers at least the
>   C and B revisions.
> * General cleanup.
> 
> Signed-off-by: Gyungoh Yoo <jack.yoo@maxim-ic.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com> #v3
Patch applied now, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
