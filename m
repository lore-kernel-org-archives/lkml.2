Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1LWQeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:34:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:12929 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab1LWQed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:34:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="50131081"
Subject: Re: [PATCH 0/3] dmaengine: intel_mid_dma: fixes
From: Vinod Koul <vinod.koul@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
In-Reply-To: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
References: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 22:04:36 +0530
Message-ID: <1324658076.1633.24.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 11:01 +0200, Adrian Hunter wrote:
> Hi
> 
> Here are some minor fixes:
> 
> Adrian Hunter (2):
>       dmaengine: intel_mid_dma: locking and freeing fixes
>       dmaengine: intel_mid_dma: error path fix
> 
> Kristen Carlson Accardi (1):
>       dmaengine: intel_mid_dma: remove legacy pm interface
> 
>  drivers/dma/intel_mid_dma.c      |   25 ++++++++++++++++++-------
>  drivers/dma/intel_mid_dma_regs.h |    2 +-
>  2 files changed, 19 insertions(+), 8 deletions(-)
> 
Applied, 1 and 2.
3 we need some more discussion.

-- 
~Vinod

