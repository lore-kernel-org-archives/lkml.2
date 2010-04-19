Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0DSVyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:54:01 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:45978 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab0DSVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:53:22 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 5/5] uml: Clean up asm/system.h
Date: Mon, 19 Apr 2010 23:53:08 +0200
Message-Id: <e89d636e305d095f5919c0e22cf92159c4067018.1271713955.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1271713955.git.jan.kiszka@web.de>
References: <cover.1271713955.git.jan.kiszka@web.de>
In-Reply-To: <cover.1271713955.git.jan.kiszka@web.de>
References: <cover.1271713955.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX19Eg1VsZRvRLpzsMlTsBMa7wHVKaGPYyY4Fg+CT
	u+4glKU1l9ZfmpTLTb4YHMW5afB4GJLjXS5kPUBLib1ZhQ1bIn
	cIkWpsmpo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicates and unused prototypes.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 arch/um/include/asm/system.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/um/include/asm/system.h b/arch/um/include/asm/system.h
index 753346e..93af1cf 100644
--- a/arch/um/include/asm/system.h
+++ b/arch/um/include/asm/system.h
@@ -3,11 +3,8 @@
 
 #include "sysdep/system.h"
 
-extern void *switch_to(void *prev, void *next, void *last);
-
 extern int get_signals(void);
 extern int set_signals(int enable);
-extern int get_signals(void);
 extern void block_signals(void);
 extern void unblock_signals(void);
 
-- 
1.6.0.2

