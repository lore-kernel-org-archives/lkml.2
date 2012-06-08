Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833Ab2FHViG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:38:06 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1684 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760208Ab2FHViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:38:05 -0400
Message-ID: <1339191479.30984.14.camel@x61.thuisdomein>
Subject: [PATCH] h8300: delete target_time.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 23:37:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 21:37:58.0997 (UTC) FILETIME=[F929A050:01CD45BE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 81d423e280d193d351f41eacdb3f82c3bb9610c1 ("h8300: update timer
handler - misc update") deleted the last #include of target_time.h.
Commit 4b6aba51fb64071e22dad7b971c73af61916a48b ("h8300: update timer
handler - delete files") deleted the definitions of the functions that
target_time.h declares. This header is unused and can safely be deleted.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested mainly with "git grep". Obviously correct. 

 arch/h8300/include/asm/target_time.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)
 delete mode 100644 arch/h8300/include/asm/target_time.h

diff --git a/arch/h8300/include/asm/target_time.h b/arch/h8300/include/asm/target_time.h
deleted file mode 100644
index 9f2a9aa..0000000
--- a/arch/h8300/include/asm/target_time.h
+++ /dev/null
@@ -1,4 +0,0 @@
-extern int platform_timer_setup(void (*timer_int)(int, void *, struct pt_regs *));
-extern void platform_timer_eoi(void);
-extern void platform_gettod(unsigned int *year, unsigned int *mon, unsigned int *day, 
-                            unsigned int *hour, unsigned int *min, unsigned int *sec);
-- 
1.7.7.6

