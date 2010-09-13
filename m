Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0IMTsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:23 -0400
Received: from mail.perches.com ([173.55.12.10]:1828 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0IMTsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:22 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 01/25] arch/mips: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:39 -0700
Message-Id: <8fcec0d2a48e806558e6bc39d5aa98518a97f8c7.1284406638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/pnx8550/common/reset.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/pnx8550/common/reset.c b/arch/mips/pnx8550/common/reset.c
index fadd874..e0ac0b2 100644
--- a/arch/mips/pnx8550/common/reset.c
+++ b/arch/mips/pnx8550/common/reset.c
@@ -27,8 +27,8 @@
 
 void pnx8550_machine_restart(char *command)
 {
-	char head[] = "************* Machine restart *************";
-	char foot[] = "*******************************************";
+	static const char head[] = "************* Machine restart *************";
+	static const char foot[] = "*******************************************";
 
 	printk("\n\n");
 	printk("%s\n", head);
-- 
1.7.3.rc1

