Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab1C1QfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:35:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab1C1QaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s9KK0k6oqFeboD4Lp1xpsaFXnrsAG2qSErNt6WFzUmvpx1kaNuwLZpfzScVNVlXago
         TMxdwikyR5cZeAgrpQTIhx4/JkpFI5MzHv37OEBTaaox1NqVv0953LG60K/YPUUjSIc2
         RQIu7Y7558/J/SdfPXeJ1GgHo5qF0fyCDVfJo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/25]arch:s390 Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:29 -0700
Message-Id: <1301329788-3423-7-git-send-email-justinmattock@gmail.com>
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
 arch/s390/kernel/vdso32/note.S |    1 -
 arch/s390/kernel/vdso64/note.S |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/vdso32/note.S b/arch/s390/kernel/vdso32/note.S
index 79a071e..6889a22 100644
--- a/arch/s390/kernel/vdso32/note.S
+++ b/arch/s390/kernel/vdso32/note.S
@@ -4,7 +4,6 @@
  */
 
 #include <linux/uts.h>
-#include <linux/version.h>
 #include <linux/elfnote.h>
 
 ELFNOTE_START(Linux, 0, "a")
diff --git a/arch/s390/kernel/vdso64/note.S b/arch/s390/kernel/vdso64/note.S
index 79a071e..6889a22 100644
--- a/arch/s390/kernel/vdso64/note.S
+++ b/arch/s390/kernel/vdso64/note.S
@@ -4,7 +4,6 @@
  */
 
 #include <linux/uts.h>
-#include <linux/version.h>
 #include <linux/elfnote.h>
 
 ELFNOTE_START(Linux, 0, "a")
-- 
1.7.4.1

