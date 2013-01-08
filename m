Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3AHLTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:19:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:42521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab3AHLTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:19:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="269204689"
Date: Tue, 8 Jan 2013 02:54:47 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: djbw@fb.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/2] dma: tegra: add channel wise pause control support
 and Tegra114 SoCs.
Message-ID: <20130108105447.GG19691@intel.com>
References: <1357489323-21359-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357489323-21359-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2013 at 09:52:01PM +0530, Laxman Dewangan wrote:
> This patch series add the channel wise pause control on dma driver and then
> add support for Tegra114 SoCs.
> 
> The orginal change was in single patch and based on review comment, trying to split
> the change to have more meaningful changelog matches with actual code change.
Applied thanks

Can you check my next, I got some conflicts and resolved them manually

--
~Vinod
> 
> 
> Laxman Dewangan (2):
>   dma: tegra: add support for channel wise pause
>   dma: tegra: add support for Tegra114 SoC
> 
>  drivers/dma/tegra20-apb-dma.c |   54 +++++++++++++++++++++++++++++++++++++----
>  1 files changed, 49 insertions(+), 5 deletions(-)
> 
