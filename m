Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2J2RkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:40:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33364 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998Ab2J2RkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:40:05 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 1/3] x86, AMD: Change Boris' email address
Date: Mon, 29 Oct 2012 18:40:08 +0100
Message-Id: <1351532410-4887-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to private email and put in maintained status.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 698b6ec12e0f..1ac581f38dfa 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -6,7 +6,7 @@
  *
  *  Written by Jacob Shin - AMD, Inc.
  *
- *  Support: borislav.petkov@amd.com
+ *  Maintained by: Borislav Petkov <bp@alien8.de>
  *
  *  April 2006
  *     - added support for AMD Family 0x10 processors
-- 
1.8.0

