Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2FBUgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:36:53 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:36107 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965183Ab2FBUf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:35:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/5] h8300/uaccess: Add mising __clear_user()
Date: Sat,  2 Jun 2012 22:35:39 +0200
Message-Id: <1338669339-23214-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
References: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/regset.h: In function 'user_regset_copyout_zero':
include/linux/regset.h:289:3: error: implicit declaration of function '__clear_user' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/h8300/include/asm/uaccess.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/include/asm/uaccess.h b/arch/h8300/include/asm/uaccess.h
index 534394f..8725d1a 100644
--- a/arch/h8300/include/asm/uaccess.h
+++ b/arch/h8300/include/asm/uaccess.h
@@ -158,4 +158,6 @@ clear_user(void *to, unsigned long n)
 	return 0;
 }
 
+#define __clear_user	clear_user
+
 #endif /* _H8300_UACCESS_H */
-- 
1.7.0.4

