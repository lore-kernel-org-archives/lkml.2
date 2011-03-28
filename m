Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1C1QaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1C1QaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jHcgz8tXV1kGytT19659GwoHZSfOBBQ4/LxLxLlyPO7QcktJBXy7ElkDeMOtRVll4S
         10kiTCiB6hz3SchoEQIOSOP6Y2utyn8KoNDT1RL0nn+WK7C5OGddd61cM8OG2JutTIou
         PNiWqxX/uwfx8u8HzbWn1jXPQ1BlLf9TNAepY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 02/25]arch:arm Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:25 -0700
Message-Id: <1301329788-3423-3-git-send-email-justinmattock@gmail.com>
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
 arch/arm/include/asm/stackprotector.h |    1 -
 arch/arm/mach-bcmring/irq.c           |    1 -
 arch/arm/mach-bcmring/timer.c         |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/stackprotector.h b/arch/arm/include/asm/stackprotector.h
index de00332..14c9eb5 100644
--- a/arch/arm/include/asm/stackprotector.h
+++ b/arch/arm/include/asm/stackprotector.h
@@ -13,7 +13,6 @@
 #define _ASM_STACKPROTECTOR_H 1
 
 #include <linux/random.h>
-#include <linux/version.h>
 
 extern unsigned long __stack_chk_guard;
 
diff --git a/arch/arm/mach-bcmring/irq.c b/arch/arm/mach-bcmring/irq.c
index 84dcda0..f2d9af8 100644
--- a/arch/arm/mach-bcmring/irq.c
+++ b/arch/arm/mach-bcmring/irq.c
@@ -20,7 +20,6 @@
 #include <linux/stddef.h>
 #include <linux/list.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/io.h>
 
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-bcmring/timer.c b/arch/arm/mach-bcmring/timer.c
index 2d415d2..af9c3d7 100644
--- a/arch/arm/mach-bcmring/timer.c
+++ b/arch/arm/mach-bcmring/timer.c
@@ -12,7 +12,6 @@
 * consent.
 *****************************************************************************/
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <csp/tmrHw.h>
-- 
1.7.4.1

