Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1DGXjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:39:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62844 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1DGXjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=A0qc7C5YhphJHx0FSI3Pc9VFV9c+lk0QO+7DCaloHmtaZ7rfr1aaZGM1IBzp58MPQc
         jPCwGIrlwns4+uBE0SiUFC2d6JQXGj91izytO5wvKlj6UPkna7vZsUDD80L+faQS1EcU
         ETJ3arIg1KbeJe+jYZXiY8/FlLjMee2Kchh/g=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=201/5=20V2=5Darch=3Acommon=3AMakefile=20Remove=20unused=20config=20in=20the=20Makefile=2E?=
Date: Thu,  7 Apr 2011 16:38:49 -0700
Message-Id: <1302219529-8864-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused config variable found by using a kernel
cleanup script.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/common/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
index e7521bca..6ea9b6f 100644
--- a/arch/arm/common/Makefile
+++ b/arch/arm/common/Makefile
@@ -16,5 +16,4 @@ obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
 obj-$(CONFIG_ARCH_IXP2000)	+= uengine.o
 obj-$(CONFIG_ARCH_IXP23XX)	+= uengine.o
 obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
-obj-$(CONFIG_COMMON_CLKDEV)	+= clkdev.o
 obj-$(CONFIG_ARM_TIMER_SP804)	+= timer-sp.o
-- 
1.7.4.2

