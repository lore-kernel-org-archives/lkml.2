Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2GPMeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:34:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:43089 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2GPMd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:33:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="172632209"
Date: Mon, 16 Jul 2012 14:34:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: Re: [PATCH V3 0/7] Initial release of Samsung S2MPS11 pmic driver
Message-ID: <20120716123402.GB20652@sortiz-mobl>
References: <012801cd5f5d$977580f0$c66082d0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012801cd5f5d$977580f0$c66082d0$@com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HiSangbeom,

On Wed, Jul 11, 2012 at 09:06:24PM +0900, Sangbeom Kim wrote:
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
> This patch is based on the samuel's mfd/for-next branch.
Thanks. All MFD patches applied to my for-next branch now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
