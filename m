Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1C1QaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54277 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab1C1QaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BeOBAiS+mGHHxx4SkpZ4XWJ5qVulBP0f4y3jE0Pi58TneDF0n6ESxvIl75DJCyk5CF
         QEhYsALWWpkuWwaKpGvm3n8jISoeK/u2qttFunIjE+szdzLgV92VZInIBdlCxjA12SFR
         xEIPKrZeuyMCbZX8McMxEPYTUCIdOGzxHQl50=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/25]arch:powerpc Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:28 -0700
Message-Id: <1301329788-3423-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/powerpc/kernel/vdso32/note.S       |    1 -
 arch/sh/kernel/vsyscall/vsyscall-note.S |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vdso32/note.S b/arch/powerpc/kernel/vdso32/note.S
index d4b5be4..bb995b7 100644
--- a/arch/powerpc/kernel/vdso32/note.S
+++ b/arch/powerpc/kernel/vdso32/note.S
@@ -4,7 +4,6 @@
  */
 
 #include <linux/uts.h>
-#include <linux/version.h>
 
 #define ASM_ELF_NOTE_BEGIN(name, flags, vendor, type)			      \
 	.section name, flags;						      \
diff --git a/arch/sh/kernel/vsyscall/vsyscall-note.S b/arch/sh/kernel/vsyscall/vsyscall-note.S
index d4b5be4..bb995b7 100644
--- a/arch/sh/kernel/vsyscall/vsyscall-note.S
+++ b/arch/sh/kernel/vsyscall/vsyscall-note.S
@@ -4,7 +4,6 @@
  */
 
 #include <linux/uts.h>
-#include <linux/version.h>
 
 #define ASM_ELF_NOTE_BEGIN(name, flags, vendor, type)			      \
 	.section name, flags;						      \
-- 
1.7.4.1

