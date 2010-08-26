Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab0ICVtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:49:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60235 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab0ICVtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Xprp3uQiMub7aCMlz+H64u9pAXs9s+5em5s7yVHfhJjsHdPXtsZAuPuppb3+lfauWa
         MFvuWg7m97S9dmSum+ugonh3ham4OyvqcljcyWWWu4UO8VIYIm5HVGiGWK5peggixek/
         /IlkIiD8uLBrXOOAXPW/gF3Y6zALBejfN8U4A=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 3/6] ARM: pxa168: added wake clear register support for APMU
Date: Thu, 26 Aug 2010 11:27:34 -0400
Message-Id: <1282836457-5651-4-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com>
References: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com>
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

