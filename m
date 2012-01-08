Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2AHOon (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:44:43 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:41043
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab2AHOol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:44:41 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Richard Zhao <richard.zhao@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <eric.miao@linaro.org>, <patches@linaro.org>
Subject: [PATCH v4 0/2] mx-sdma: memory barrier fix
Date: Sun, 8 Jan 2012 22:44:20 +0800
Message-ID: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v4:
 - convert all _raw_readl/_raw_writel to readl/writel.

Changes in v3:
 - use writel instead of explicitly call wmb.

Changes in v2:
 - add "let sdma_run_channel call sdma_enable_channel"




Thanks
Richard

