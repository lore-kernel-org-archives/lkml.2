Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1BWFpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:45:39 -0500
Received: from mail.perches.com ([173.55.12.10]:3858 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab1BWFma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:30 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH 06/18] MAINTAINERS: Update clkdev location
Date: Tue, 22 Feb 2011 21:41:59 -0800
Message-Id: <a1d4dfcae53eb2519b9c62ea5bc329fbac642cb3.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6d803ba736abb5e122dede70a4720e4843dd6df4
("ARM: 6483/1: arm & sh: factorised duplicated clkdev.c")
moved it to a separate directory.

cc: Russell King <rmk+kernel@arm.linux.org.uk>
cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ecba76..c169e27 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -680,8 +680,8 @@ S:	Maintained
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-F:	arch/arm/common/clkdev.c
 F:	arch/arm/include/asm/clkdev.h
+F:	drivers/clk/clkdev.c
 
 ARM/COMPULAB CM-X270/EM-X270 and CM-X300 MACHINE SUPPORT
 M:	Mike Rapoport <mike@compulab.co.il>
-- 
1.7.4.rc3

