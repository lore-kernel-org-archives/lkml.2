Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab2F0N7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:59:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:47993 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2F0N7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:59:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161306557"
Subject: Re: [PATCH 1/2] dma: tegra: set DMA_CYCLIC capability
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <4FEB0DB6.7040105@nvidia.com>
References: <1340365364-16276-1-git-send-email-ldewangan@nvidia.com>
	 <1340803748.1562.244.camel@vkoul-udesk3>  <4FEB0DB6.7040105@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jun 2012 19:19:23 +0530
Message-ID: <1340804963.1562.257.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 19:12 +0530, Laxman Dewangan wrote:
> Not really,
> I called dma_cookie_complete() only from the isr
> handle_once_dma_done() 
> which is only called if it is non-cyclic mode.
Ah got it my bad.

Applied now, Thanks 
-- 
~Vinod

