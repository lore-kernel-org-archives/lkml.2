Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2AMDKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:10:19 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:29514 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2AMDKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:10:13 -0500
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1202hzzz2dhc1ahc1bh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <eric.miao@linaro.org>, <patches@linaro.org>
Subject: [PATCH v2 0/6] imx-sdma: patches when I enable imx6q sabrelite audio
Date: Fri, 13 Jan 2012 11:09:55 +0800
Message-ID: <1326424201-20056-1-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v2 1/6] dma/imx-sdma: let sdma_run_channel call
[PATCH v2 2/6] dma/imx-sdma: use readl_relaxed/writel_relaxed and
[PATCH v2 3/6] dma/imx-sdma: call sdma_set_channel_priority after
[PATCH v2 4/6] dma/imx-sdma: move clk_enable out of
[PATCH v2 5/6] dma/imx-sdma: use num_events to validate event_id0
[PATCH v2 6/6] dma/imx-sdma: convernt to use bit ops

Thanks
Richard

