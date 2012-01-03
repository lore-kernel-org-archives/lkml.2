Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab2ACHHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:07:49 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:53241 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2ACHHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:07:47 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH] MFD: Clearing events requires event registers to be
 writable for da9052-core
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <arnd@arndb.de>, <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 3 Jan 2012 12:33:26 +0530
Message-ID: <1325574206.4643.8.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/mfd/da9052-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index a7c115c..1876aa9 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -172,6 +172,10 @@ static bool da9052_reg_writeable(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case DA9052_PAGE0_CON_REG:
+	case DA9052_EVENT_A_REG:
+	case DA9052_EVENT_B_REG:
+	case DA9052_EVENT_C_REG:
+	case DA9052_EVENT_D_REG:
 	case DA9052_IRQ_MASK_A_REG:
 	case DA9052_IRQ_MASK_B_REG:
 	case DA9052_IRQ_MASK_C_REG:


