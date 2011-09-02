Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1IBL3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 07:29:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:36141 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab1IBL3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 07:29:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,318,1312182000"; 
   d="scan'208";a="48078358"
Subject: Re: [PATCH 0/4] dmaeninge/ste_dma40: bug fixes for 3.1
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linaro-dev@lists.linaro.org
In-Reply-To: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
References: <1314617615-2394-1-git-send-email-per.forlin@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 16:57:19 +0530
Message-ID: <1314962839.26251.47.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 13:33 +0200, Per Forlin wrote:
> Started off fixing a memory leak due to not freed dma descriptors
> in mmci. The descriptor allocated at device_prep...(), not submitted,
> isn't freed at dmaeninge_terminate_all() or dmaengine_release().
> While sorting this one out some other issues were found as well.
> * kernel doc missing
> * duplication of d40_pool_lli_free()
> * free of client descriptor triggers an oops.
> 
> Per Forlin (4):
>   dmaengine/ste_dma40: add missing kernel doc for pending_queue
>   dmaengine/ste_dma40: remove duplicate call to d40_pool_lli_free().
>   dmaengine/ste_dma40: fix Oops due to double free of client descriptor
>   dmaengine/ste_dma40: fix memory leak due to prepared descriptors
> 
>  drivers/dma/ste_dma40.c |   42 +++++++++++++++++++++++++++++-------------
>  1 files changed, 29 insertions(+), 13 deletions(-)
> 
Applied, Thanks

-- 
~Vinod

