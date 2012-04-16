Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab2DPPXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:23:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:51500 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab2DPPXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:23:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131487868"
Date: Mon, 16 Apr 2012 17:32:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        k.lewandowsk@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v4 1/2] mfd: add irq domain support for max8997 interrupts
Message-ID: <20120416153224.GF24130@sortiz-mobl>
References: <1332582590-16382-1-git-send-email-thomas.abraham@linaro.org>
 <1332582590-16382-2-git-send-email-thomas.abraham@linaro.org>
 <20120404212257.GE10787@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404212257.GE10787@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Apr 04, 2012 at 10:22:57PM +0100, Mark Brown wrote:
> On Sat, Mar 24, 2012 at 03:19:49PM +0530, Thomas Abraham wrote:
> > Add irq domain support for max8997 interrupts. The reverse mapping method
> > used is linear mapping since the sub-drivers of max8997 such as regulator
> > and charger drivers can use the max8997 irq_domain to get the linux irq
> > number for max8997 interrupts. All uses of irq_base in platform data and
> > max8997 driver private data are removed.
> 
> > Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> > Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> CCing in Samuel for the MFD review - review tends to be faster if you CC
> maintainers!  Samuel, there's a followup patch for the regulator API
> which is likely to collide with some API updates so is it OK to merge
> via regulator if the patch is OK?
Yes, the patch looks fine, you can merge it through the regulator tree with my

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

if you think that's necessary.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
