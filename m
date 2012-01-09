Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2AIJCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:02:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:21897 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab2AIJCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:02:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="54604640"
Date: Mon, 9 Jan 2012 10:08:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] regulator: Add S5M8767A regulator driver
Message-ID: <20120109090821.GK13679@sortiz-mobl>
References: <1325225153-32389-1-git-send-email-sbkim73@samsung.com>
 <20120108231657.GD13679@sortiz-mobl>
 <20120109064703.GT29065@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109064703.GT29065@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 10:47:04PM -0800, Mark Brown wrote:
> On Mon, Jan 09, 2012 at 12:16:57AM +0100, Samuel Ortiz wrote:
> 
> > Mark, are you ok with this one ? As it depends on the previous MFD patches,
> > I'll have to take it through the MFD tree.
> 
> I've not reviwed it yet and there should be no dependency on the MFD
> tree so no need to merge it via that - the fact that there's a Kconfig
> dependency on the MFD means that the two can get merged in any order.
Not only a Kconfig dependency, but also the regulator driver including some of
the headers defined in the mfd patch:

+#include <linux/mfd/s5m87xx/s5m-core.h>
+#include <linux/mfd/s5m87xx/s5m-pmic.h>

So, both need to get merged at the same time.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
