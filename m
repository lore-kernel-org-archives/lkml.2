Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0DSSvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:51:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56029 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0DSSvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fvdq3cJQzS2ULCJdam/M1L+C0wpkqYtHRc+2ajR+ngy8cR64Jj1jBEpEk6GzXCqZSn
         1WTnxjNGkV+K+scIsa79Y+6mmX3kt3DgShSLHp6QWPC/i94gvK6FhAHb+dRAdRSPRyrd
         pVYr8kDJH0CEVAKDPJ0pW47eUgEhBIUoJkcvo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]Fix typo in percpu.h
Date: Mon, 19 Apr 2010 11:51:16 -0700
Message-Id: <1271703076-4395-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in arch/x86/include/asm/percpu.h

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/include/asm/percpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 66a272d..9899afa 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -105,7 +105,7 @@ do {							\
 
 /*
  * Generate a percpu add to memory instruction and optimize code
- * if a one is added or subtracted.
+ * if one is added or subtracted.
  */
 #define percpu_add_op(var, val)						\
 do {									\
-- 
1.6.5.GIT

