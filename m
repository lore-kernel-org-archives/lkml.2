Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2AEH7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:59:40 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:58751 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2AEH7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:59:37 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <eric.miao@linaro.org>, <patches@linaro.org>
Subject: [PATCH v3 0/2] imx-sdma: memory barrier fix
Date: Thu, 5 Jan 2012 15:59:20 +0800
Message-ID: <1325750362-22598-1-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v3:
 - use writel instead of explicitly call wmb.

Changes in v2:
 - add "let sdma_run_channel call sdma_enable_channel"

[PATCH v3 1/2] dma/imx-sdma: let sdma_run_channel call
[PATCH v3 2/2] dma/imx-sdma: use writel to write register when

Thanks
Richard

