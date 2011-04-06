Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab1DFO4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:56:38 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47829 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755952Ab1DFO4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:56:37 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 1/1] RapidIO: Add IDT CPS-1432 switch definitions
Date: Wed,  6 Apr 2011 10:56:06 -0400
Message-Id: <1302101766-31710-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/rapidio/switches/idt_gen2.c |    1 +
 include/linux/rio_ids.h             |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/rapidio/switches/idt_gen2.c b/drivers/rapidio/switches/idt_gen2.c
index 095016a..ac2701b 100644
--- a/drivers/rapidio/switches/idt_gen2.c
+++ b/drivers/rapidio/switches/idt_gen2.c
@@ -418,3 +418,4 @@ DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1848, idtg2_switch_init);
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1616, idtg2_switch_init);
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTVPS1616, idtg2_switch_init);
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTSPS1616, idtg2_switch_init);
+DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1432, idtg2_switch_init);
diff --git a/include/linux/rio_ids.h b/include/linux/rio_ids.h
index 7410d33..0cee015 100644
--- a/include/linux/rio_ids.h
+++ b/include/linux/rio_ids.h
@@ -35,6 +35,7 @@
 #define RIO_DID_IDTCPS6Q		0x035f
 #define RIO_DID_IDTCPS10Q		0x035e
 #define RIO_DID_IDTCPS1848		0x0374
+#define RIO_DID_IDTCPS1432		0x0375
 #define RIO_DID_IDTCPS1616		0x0379
 #define RIO_DID_IDTVPS1616		0x0377
 #define RIO_DID_IDTSPS1616		0x0378
-- 
1.7.3.1

