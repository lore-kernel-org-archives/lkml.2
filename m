Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab1DZESi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:18:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:11483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1DZESh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:18:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="634058776"
Subject: Re: [PATCH V2 0/7] dmaengine/dw_dmac updates
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org, armando.visconti@st.com,
        shiraz.hashim@st.com, amit.goel@st.com, viresh.linux@gmail.com,
        linus.walleij@linaro.org
In-Reply-To: <cover.1303194835.git.viresh.kumar@st.com>
References: <cover.1303194835.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 09:16:59 +0530
Message-ID: <1303789619.896.4.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 14:02 +0530, Viresh Kumar wrote:
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
>  drivers/dma/dw_dmac.c      |  179 ++++++++++++++++++++++++++++----------------
>  drivers/dma/dw_dmac_regs.h |    2 +
>  2 files changed, 117 insertions(+), 64 deletions(-)
> 
Viresh,

The patch series fails to apply in my next. Can you please rebase to my
tree and resend again

FWIW: my tree is at git://git.infradead.org/users/vkoul/slave-dma.git

~Vinod


