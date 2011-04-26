Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1DZGjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:39:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:35142 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab1DZGjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:39:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="683960353"
Subject: Re: [PATCH V2 resend 0/7] dmaengine/dw_dmac updates
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <cover.1303796005.git.viresh.kumar@st.com>
References: <cover.1303796005.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 11:37:30 +0530
Message-ID: <1303798050.896.27.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 11:08 +0530, Viresh Kumar wrote:
> This patchset fixes few issues and extends its support.
> 
> Changes in V2:
>  - lflags added in dw_dma_chan instead of dw_dma
>  - Patch from Linus Walleij added for pause and resume functionality.
> 
> Linus Walleij (1):
>   dmaengine/dw_dmac: implement pause and resume in dwc_control
> 
> Viresh Kumar (6):
>   dmaengine/dw_dmac: Replace spin_lock_bh with irqsave variants
>   dmaengine/dw_dmac: Enable resubmission from callback routine.
>   dmaengine/dw_dmac: call dwc_descriptor_complete from dwc_control with
>     lock held
>   dmaengine/dw_dmac: don't call callback routine in case
>     dmaengine_terminate_all() is called
>   dmaengine/dw_dmac: set residue as total len in dwc_tx_status if
>     status is !DMA_SUCCESS
>   dmaengine/dw_dmac: Divide one sg to many desc, if sg len is greater
>     than DWC_MAX_COUNT
> 
>  drivers/dma/dw_dmac.c      |  205 +++++++++++++++++++++++++++-----------------
>  drivers/dma/dw_dmac_regs.h |    2 +
>  2 files changed, 129 insertions(+), 78 deletions(-)
> 
Applied thanks

-- 
~Vinod

