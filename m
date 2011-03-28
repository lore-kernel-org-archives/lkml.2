Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1C1QaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48024 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab1C1QaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oqJ+KmtlW6w9gXA+faDS+KuDViuEFg+sHs4gHSyjIH/wKb/QDG79lBDdR60aSkqeih
         GvciyoLn/41CUaIekcbBJfa2kMe7aDN+0uRuzGc5g9KZwjh4lzrV4o2cLq8FNJdqi40z
         MMpFZorxRw1n9iZcfkCJmAyP8NSdqPi8L7Rg8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 01/25]arch:x86 Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:24 -0700
Message-Id: <1301329788-3423-2-git-send-email-justinmattock@gmail.com>
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
 arch/x86/mm/mmio-mod.c      |    1 -
 arch/x86/vdso/vdso-note.S   |    1 -
 arch/x86/vdso/vdso32/note.S |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 3adff7d..c83c3d0 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/kallsyms.h>
 #include <asm/pgtable.h>
 #include <linux/mmiotrace.h>
diff --git a/arch/x86/vdso/vdso-note.S b/arch/x86/vdso/vdso-note.S
index 79a071e..6889a22 100644
--- a/arch/x86/vdso/vdso-note.S
+++ b/arch/x86/vdso/vdso-note.S
@@ -4,7 +4,6 @@
  */
 
 #include <linux/uts.h>
-#include <linux/version.h>
 #include <linux/elfnote.h>
 
 ELFNOTE_START(Linux, 0, "a")
diff --git a/arch/x86/vdso/vdso32/note.S b/arch/x86/vdso/vdso32/note.S
index c83f257..9dc7d0e 100644
--- a/arch/x86/vdso/vdso32/note.S
+++ b/arch/x86/vdso/vdso32/note.S
@@ -3,7 +3,6 @@
  * Here we can supply some information useful to userland.
  */
 
-#include <linux/version.h>
 #include <linux/elfnote.h>
 
 /* Ideally this would use UTS_NAME, but using a quoted string here
-- 
1.7.4.1

