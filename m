Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab2IXRDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:03:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47635 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab2IXRDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:03:03 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: arm@kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@xenotime.net>, Simon Arlott <simon@fire.lp0.eu>,
        Chris Boot <bootc@bootc.net>, Dom Cobley <popcornmix@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] irqchip: fill in empty Kconfig
Date: Mon, 24 Sep 2012 11:02:54 -0600
Message-Id: <1348506174-28641-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 89214f0 "ARM: bcm2835: add interrupt controller driver" added an
empty drivers/irqchip/Kconfig. Empty files apparently don't work well
with git (sometimes, with some versions?) so add some dummy content to
resolve this issue.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/irqchip/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index e69de29..1bb8bf6 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -0,0 +1 @@
+# empty
-- 
1.7.0.4

