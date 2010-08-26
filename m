Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab0HaCgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:36:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54033 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab0HaCgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vup2+5B/CF1AZzezgs2PAwjIOpJ/ao1Kg3P2l/5qnzDqpKKElCMdo01MNNn7QLwLzT
         wu3r/8A+9GdYWH9ITtBpze1RhFKoSv0nc77h52fuQ78GSmdiqCit07UAqycX2yulHsMF
         IvScKfhMy4Vf4a17QQPavSb7lDz42fnEo1pAY=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH 3/5] ARM: pxa168: added wake clear register support for APMU
Date: Thu, 26 Aug 2010 05:18:57 -0400
Message-Id: <1282814339-10934-4-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com>
References: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/include/mach/regs-apmu.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/include/mach/regs-apmu.h b/arch/arm/mach-mmp/include/mach/regs-apmu.h
index 9190305..ac47023 100644
--- a/arch/arm/mach-mmp/include/mach/regs-apmu.h
+++ b/arch/arm/mach-mmp/include/mach/regs-apmu.h
@@ -33,4 +33,16 @@
 #define APMU_FNRST_DIS	(1 << 1)
 #define APMU_AXIRST_DIS	(1 << 0)
 
+/* Wake Clear Register */
+#define APMU_WAKE_CLR	APMU_REG(0x07c)
+
+#define APMU_PXA168_KP_WAKE_CLR		(1 << 7)
+#define APMU_PXA168_CFI_WAKE_CLR	(1 << 6)
+#define APMU_PXA168_XD_WAKE_CLR		(1 << 5)
+#define APMU_PXA168_MSP_WAKE_CLR	(1 << 4)
+#define APMU_PXA168_SD4_WAKE_CLR	(1 << 3)
+#define APMU_PXA168_SD3_WAKE_CLR	(1 << 2)
+#define APMU_PXA168_SD2_WAKE_CLR	(1 << 1)
+#define APMU_PXA168_SD1_WAKE_CLR	(1 << 0)
+
 #endif /* __ASM_MACH_REGS_APMU_H */
-- 
1.7.0.4

