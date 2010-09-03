Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab0ICW3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:29:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64111 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0ICW3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LPXUNVoXD5zkkt2LY6BN2kq1yf8c7uPMFYjawCuymg6QfG3Ur3YmVDbALuxsTiyNqk
         pu/ZaAHFoP0rhuMoi6p0tk/qHoRc9tll91/jSvY4ztP6yMBtZaUFIceFtxcptvVWShbm
         aVKti7ClqOErNrJXQbumKeSSVVuosxlTYK57s=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 3/6 RESEND] ARM: pxa168: added wake clear register support for APMU
Date: Fri,  3 Sep 2010 18:28:08 -0400
Message-Id: <1283552891-13966-4-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283552891-13966-1-git-send-email-mark.brown314@gmail.com>
References: <1283552891-13966-1-git-send-email-mark.brown314@gmail.com>
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

