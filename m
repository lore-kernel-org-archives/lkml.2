Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab1C1Qfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:35:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48024 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab1C1QaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JQjnMRLfaCtauQ+wZUdSKfbH0eygJaUdQXtwbxcfm52den+kVC3Fh12ymWGM6jKhKt
         i6RFcAWD+Fvg6s0K/gt7/UTumfcA78AaicGi3YkjK2oVZ5RnwrXOI34pwFKrdQoRHHzw
         uLlk46NIAHaZp4GtfpdkU84PhxkHexDxL+JBs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 04/25]arch:sparc Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:27 -0700
Message-Id: <1301329788-3423-5-git-send-email-justinmattock@gmail.com>
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
 arch/sparc/kernel/head_32.S |    1 -
 arch/sparc/kernel/head_64.S |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/head_32.S b/arch/sparc/kernel/head_32.S
index 5942349..5de603f 100644
--- a/arch/sparc/kernel/head_32.S
+++ b/arch/sparc/kernel/head_32.S
@@ -10,7 +10,6 @@
  * CompactPCI platform by Eric Brower, 1999.
  */
 
-#include <linux/version.h>
 #include <linux/init.h>
 
 #include <asm/head.h>
diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index f8f2105..eeaa723 100644
--- a/arch/sparc/kernel/head_64.S
+++ b/arch/sparc/kernel/head_64.S
@@ -6,7 +6,6 @@
  * Copyright (C) 1997 Miguel de Icaza (miguel@nuclecu.unam.mx)
  */
 
-#include <linux/version.h>
 #include <linux/errno.h>
 #include <linux/threads.h>
 #include <linux/init.h>
-- 
1.7.4.1

