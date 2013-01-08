Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3AHQCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:02:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:53799 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab3AHQCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:02:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,432,1355126400"; 
   d="scan'208";a="241329727"
Date: Tue, 8 Jan 2013 07:37:42 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: mxs-dma: Fix build warnings with W=1
Message-ID: <20130108153742.GH19691@intel.com>
References: <1357609719-10493-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357609719-10493-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 11:48:39PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Fix the following warnings when building with W=1 option:
> 
> drivers/dma/mxs-dma.c: In function 'mxs_dma_alloc_chan_resources':
> drivers/dma/mxs-dma.c:368:25: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/dma/mxs-dma.c: In function 'mxs_dma_prep_slave_sg':
> drivers/dma/mxs-dma.c:481:17: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/dma/mxs-dma.c:494:3: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/dma/mxs-dma.c:515:14: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> drivers/dma/mxs-dma.c: In function 'mxs_dma_prep_dma_cyclic':
> drivers/dma/mxs-dma.c:563:13: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> 
Applied thanks

--
~Vinod
