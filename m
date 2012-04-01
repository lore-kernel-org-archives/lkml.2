Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2DAQCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:02:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2DAQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:02:51 -0400
Subject: [RFC PATCH -tip 02/16] x86: Change the order of segment prefix macro
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:02:47 +0900
Message-ID: <20120401160247.4502.89004.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the order of segment prefix macros to fit
intel's segment register order.'s segment register order.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/include/asm/inat.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index 55e438b..2a86c26 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -36,12 +36,12 @@
 #define INAT_PFX_REPNE	3	/* 0xF2 */ /* LPFX3 */
 /* Other Legacy prefixes */
 #define INAT_PFX_LOCK	4	/* 0xF0 */
-#define INAT_PFX_CS	5	/* 0x2E */
-#define INAT_PFX_DS	6	/* 0x3E */
-#define INAT_PFX_ES	7	/* 0x26 */
-#define INAT_PFX_FS	8	/* 0x64 */
-#define INAT_PFX_GS	9	/* 0x65 */
-#define INAT_PFX_SS	10	/* 0x36 */
+#define INAT_PFX_ES	5	/* 0x26 */
+#define INAT_PFX_CS	6	/* 0x2E */
+#define INAT_PFX_SS	7	/* 0x36 */
+#define INAT_PFX_DS	8	/* 0x3E */
+#define INAT_PFX_FS	9	/* 0x64 */
+#define INAT_PFX_GS	10	/* 0x65 */
 #define INAT_PFX_ADDRSZ	11	/* 0x67 */
 /* x86-64 REX prefix */
 #define INAT_PFX_REX	12	/* 0x4X */

