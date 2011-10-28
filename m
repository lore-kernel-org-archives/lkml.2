Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1J1Rwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:52:43 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:48293 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1J1Rwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:52:41 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 04/13] mtd/docg3: fix BCH registers
Date: Fri, 28 Oct 2011 19:51:23 +0200
Message-Id: <1319824292-11085-5-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BCH registers are contiguous, not on every byte. Fix the
register definitions.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/docg3.h b/drivers/mtd/devices/docg3.h
index 0d407be..62af5aa 100644
--- a/drivers/mtd/devices/docg3.h
+++ b/drivers/mtd/devices/docg3.h
@@ -105,7 +105,7 @@
 #define DOC_ECCCONF1			0x1042
 #define DOC_ECCPRESET			0x1044
 #define DOC_HAMMINGPARITY		0x1046
-#define DOC_BCH_SYNDROM(idx)		(0x1048 + (idx << 1))
+#define DOC_BCH_SYNDROM(idx)		(0x1048 + (idx << 0))
 
 #define DOC_PROTECTION			0x1056
 #define DOC_DPS0_ADDRLOW		0x1060
-- 
1.7.5.4

