Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab2AMDOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:14:00 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:47480 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2AMDN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:13:59 -0500
X-SpamScore: -3
X-BigFish: VS-3(zcb8kz1432Nzz1202hzz8275dhz2dhc1ahc1bh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 13 Jan 2012 11:13:50 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Richard Zhao <richard.zhao@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <vinod.koul@intel.com>, <eric.miao@linaro.org>,
        <kernel@pengutronix.de>, <dan.j.williams@intel.com>,
        <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 0/6] imx-sdma: patches when I enable imx6q sabrelite
 audio
Message-ID: <20120113031349.GH2414@b20223-02.ap.freescale.net>
References: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
 - convert to use bit ops

> [PATCH v2 1/6] dma/imx-sdma: let sdma_run_channel call
> [PATCH v2 2/6] dma/imx-sdma: use readl_relaxed/writel_relaxed and
> [PATCH v2 3/6] dma/imx-sdma: call sdma_set_channel_priority after
> [PATCH v2 4/6] dma/imx-sdma: move clk_enable out of
> [PATCH v2 5/6] dma/imx-sdma: use num_events to validate event_id0
> [PATCH v2 6/6] dma/imx-sdma: convernt to use bit ops
> 
> Thanks
> Richard
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

