Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0KKXST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:18:19 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:33716 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0KKXST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:18:19 -0500
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: mark CONFIG_HIGHMEM as broken
Date: Fri, 12 Nov 2010 00:18:08 +0100
Message-Id: <1289517488-17628-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently CONFIG_HIGHMEM is broken on User Mode Linux.
I'm not sure if it worked ever.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.um |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index 50d6aa2..f8d1d0d 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -131,7 +131,7 @@ config NR_CPUS
 
 config HIGHMEM
 	bool "Highmem support (EXPERIMENTAL)"
-	depends on !64BIT && EXPERIMENTAL
+	depends on !64BIT && BROKEN
 	default n
 	help
 	  This was used to allow UML to run with big amounts of memory.
-- 
1.6.6.1

