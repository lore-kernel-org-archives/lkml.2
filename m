Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3AFPBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 10:01:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:34209 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab3AFPBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 10:01:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,419,1355126400"; 
   d="scan'208";a="268224499"
Date: Sun, 6 Jan 2013 06:37:38 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: djbw@fb.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: add support for Tegra114 SoC
Message-ID: <20130106143738.GC29209@intel.com>
References: <1357387568-26010-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357387568-26010-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 05:36:08PM +0530, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has APB DMA controller which supports channel wise
> pause control. The global pause is used for clock gating and hence
> DMA registers are not accessible if DMAs are globally disabled.
> 
> Add support for use of channel wise pause feature for Tegra114 SOCs.
Looks fine to me. Only issue being that changelog tells me you are adding
support for 114, but patch seems more of adding pause support and while at it
also add entries for 114. 
Care to update changelog & title...

--
~Vinod
