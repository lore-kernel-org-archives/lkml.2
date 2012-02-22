Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2BVMm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:42:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:64741 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab2BVMmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:42:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120059469"
Subject: Re: [PATCH 0/2] dmaengine: intel_mid_dma: minor fixes
From: Vinod Koul <vinod.koul@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1328006940-9101-1-git-send-email-adrian.hunter@intel.com>
References: <1328006940-9101-1-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Feb 2012 18:14:24 +0530
Message-ID: <1329914664.24656.96.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 12:48 +0200, Adrian Hunter wrote:
> Hi
> 
> Here are 2 minor fixes for intel_mid_dma.
> 
> 
> Adrian Hunter (2):
>       dmaengine: intel_mid_dma: fix error status mask
>       dmaengine: intel_mid_dma: move pm_runtime_put
> 
>  drivers/dma/intel_mid_dma.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
Applied, Thanks


-- 
~Vinod

