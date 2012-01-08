Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2AHXTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:19:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:23074 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab2AHXTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:19:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104875108"
Date: Mon, 9 Jan 2012 00:25:30 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jin Park <jinyoungp@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Convert aat2870 to dev_pm_ops
Message-ID: <20120108232530.GG13679@sortiz-mobl>
References: <1325094028-8501-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325094028-8501-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Dec 28, 2011 at 05:40:28PM +0000, Mark Brown wrote:
> The I2C suspend and resume functions have been deprecated since the driver
> was introduced.
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
