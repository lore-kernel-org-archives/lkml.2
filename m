Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2ILWuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:50:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52217 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2ILWut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:50:49 -0400
From: Tracey Dent <tdent48227@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, blogic@openwrt.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 1/1] Arch: mips: Delete Makefile.rej
Date: Wed, 12 Sep 2012 18:50:39 -0400
Message-Id: <1347490239-1351-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.10.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefile.rej should not be there. That was introduced
in commit 3fa68afc3d774bab1e91cbb3a3cdd1e36068ee95 .

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 arch/mips/lantiq/xway/Makefile.rej |    5 -----
 1 file changed, 5 deletions(-)
 delete mode 100644 arch/mips/lantiq/xway/Makefile.rej

diff --git a/arch/mips/lantiq/xway/Makefile.rej b/arch/mips/lantiq/xway/Makefile.rej
deleted file mode 100644
index 8066520..0000000
--- a/arch/mips/lantiq/xway/Makefile.rej
+++ /dev/null
@@ -1,5 +0,0 @@
---- arch/mips/lantiq/xway/Makefile
-+++ arch/mips/lantiq/xway/Makefile
-@@ -1 +1 @@
--obj-y := prom.o sysctrl.o clk.o reset.o gpio.o dma.o
-+obj-y := prom.o sysctrl.o clk.o reset.o dma.o
-- 
1.7.10.rc4

