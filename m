Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab2IOWvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 18:51:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:29115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2IOWvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 18:51:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,428,1344236400"; 
   d="scan'208";a="222531133"
Date: Sun, 16 Sep 2012 00:51:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Gyungoh Yoo <jack.yoo@maxim-ic.com>, devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 REPOST] mfd: add MAX8907 core driver
Message-ID: <20120915225142.GI3647@sortiz-mobl>
References: <1346973015-7252-1-git-send-email-swarren@wwwdotorg.org>
 <5050B850.807@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050B850.807@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Sep 12, 2012 at 10:29:04AM -0600, Stephen Warren wrote:
> On 09/06/2012 05:10 PM, Stephen Warren wrote:
> > From: Gyungoh Yoo <jack.yoo@maxim-ic.com>
> > 
> > The MAX8907 is an I2C-based power-management IC containing voltage
> > regulators, a reset controller, a real-time clock, and a touch-screen
> > controller.
> 
> Samuel,
> 
> This patch as-is won't compile due to the mfd_add_devices() API change.
> Do you want to fix this up when you apply (simply add an extra parameter
> "NULL" to the mfd_add_devices() call), or should I send an updated V5
> for this?
I'll fix it up, don't bother sending a v5.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
