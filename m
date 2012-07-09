Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2GILBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:01:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:24902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2GILBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:01:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="163259290"
Date: Mon, 9 Jul 2012 13:13:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>,
        sbkim01@gmail.com
Subject: Re: [PATCH V2 0/7] Initial release of Samsung S2MPS11 pmic driver
Message-ID: <20120709111308.GL15345@sortiz-mobl>
References: <0fed01cd5c24$5dd3ebc0$197bc340$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fed01cd5c24$5dd3ebc0$197bc340$@com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangbeom,

On Sat, Jul 07, 2012 at 06:39:12PM +0900, Sangbeom Kim wrote:
> The S2MPS11 is comprised of high efficient Buck converters,
> various LDOs, and an RTC and tightly coupled with Multi Core Samsung 
> Application Processors, which is used in a wide variety of mobile applications
> such as smart phones and tablet PCs.
> S2MPS11 provide 10 high efficiency buck converters and 38 LDO regulators.
> Especially, Buck2 can support 7.0A current capacity for high performance
> samsung application processor.
> Most of S2MPS11 feature are similar to S5M series.
> and Instead of using s5m prefix, Samsung decide to use s2m prefix.
> So, I try to make common mfd driver for S2M and S5M series.
> Most of s5m prefix is changed into sec prefix.
> 
> Changes since V1:
> 1. Replace list_voltage with standard framework
> 2. Apply regmap_irq
> 3. Minor changes.
I was trying to apply this patchset to my for-next branch, but it doesn't
apply properly.
Could you please rebase it against this branch and send it to me ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
