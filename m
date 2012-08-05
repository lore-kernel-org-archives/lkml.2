Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2HEOpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:45:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44723 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2HEOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:45:49 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ARM: kirkwood: fix typo in Makefile.boot
Date: Sun,  5 Aug 2012 16:45:32 +0200
Message-Id: <1344177932-6466-1-git-send-email-sebastian.hesselbarth@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a small typo fix to make lsxl dtbs compile

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/Makefile.boot |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-kirkwood/Makefile.boot b/arch/arm/mach-kirkwood/Makefile.boot
index 2a576ab..a571755 100644
--- a/arch/arm/mach-kirkwood/Makefile.boot
+++ b/arch/arm/mach-kirkwood/Makefile.boot
@@ -9,5 +9,5 @@ dtb-$(CONFIG_MACH_ICONNECT_DT) += kirkwood-iconnect.dtb
 dtb-$(CONFIG_MACH_IB62X0_DT) += kirkwood-ib62x0.dtb
 dtb-$(CONFIG_MACH_TS219_DT)	+= kirkwood-qnap-ts219.dtb
 dtb-$(CONFIG_MACH_GOFLEXNET_DT) += kirkwood-goflexnet.dtb
-dbt-$(CONFIG_MACH_LSXL_DT) += kirkwood-lschlv2.dtb
-dbt-$(CONFIG_MACH_LSXL_DT) += kirkwood-lsxhl.dtb
+dtb-$(CONFIG_MACH_LSXL_DT) += kirkwood-lschlv2.dtb
+dtb-$(CONFIG_MACH_LSXL_DT) += kirkwood-lsxhl.dtb
-- 
1.7.10.4

