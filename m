Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2GaKpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:45:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:28131 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab2GaKp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:45:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128777616"
Subject: Re: [PATCH V2] dma: tegra: enable/disable dma clock
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: dan.j.williams@intel.com, swarren@nvidia.com, linux-kernel@vger.kernel.org
In-Reply-To: <1342771268-5252-1-git-send-email-ldewangan@nvidia.com>
References: <1342771268-5252-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jul 2012 16:16:24 +0530
Message-ID: <1343731584.1726.14411.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 13:31 +0530, Laxman Dewangan wrote:
> Enable the DMA clock when allocating channel and
> disable clock when freeing channels.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Thanks Applied to for-3.7


-- 
~Vinod

