Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0LJVx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:53:26 -0500
Received: from mxout1.idt.com ([157.165.5.25]:42426 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0LJVxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:53:24 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH] RapidIO: Add new IDT sRIO switches
Date: Fri, 10 Dec 2010 16:52:52 -0500
Message-Id: <1292017972-6261-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new sRIO switch device IDs and enable a basic support for them.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
---
 drivers/rapidio/switches/idt_gen2.c |    2 ++
 include/linux/rio_ids.h             |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/rapidio/switches/idt_gen2.c b/drivers/rapidio/switches/idt_gen2.c
index dd4b2b7..095016a 100644
--- a/drivers/rapidio/switches/idt_gen2.c
+++ b/drivers/rapidio/switches/idt_gen2.c
@@ -416,3 +416,5 @@ static int idtg2_switch_init(struct rio_dev *rdev, int do_enum)
 
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1848, idtg2_switch_init);
 DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTCPS1616, idtg2_switch_init);
+DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTVPS1616, idtg2_switch_init);
+DECLARE_RIO_SWITCH_INIT(RIO_VID_IDT, RIO_DID_IDTSPS1616, idtg2_switch_init);
diff --git a/include/linux/rio_ids.h b/include/linux/rio_ids.h
index ee7b6ad..7410d33 100644
--- a/include/linux/rio_ids.h
+++ b/include/linux/rio_ids.h
@@ -36,5 +36,7 @@
 #define RIO_DID_IDTCPS10Q		0x035e
 #define RIO_DID_IDTCPS1848		0x0374
 #define RIO_DID_IDTCPS1616		0x0379
+#define RIO_DID_IDTVPS1616		0x0377
+#define RIO_DID_IDTSPS1616		0x0378
 
 #endif				/* LINUX_RIO_IDS_H */
-- 
1.7.3.1

