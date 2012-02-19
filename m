Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2BSPMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 10:12:09 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:46551 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2BSPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 10:12:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: [PATCH 3/5] x86: s/#if CONFIG/#ifdef CONFIG/
Date: Sun, 19 Feb 2012 16:11:57 +0100
Message-Id: <1329664319-3128-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>"
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
---
 arch/x86/boot/compressed/head_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index a055993..a37b117 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -173,7 +173,7 @@ relocated:
 	call	decompress_kernel
 	addl	$20, %esp
 
-#if CONFIG_RELOCATABLE
+#ifdef CONFIG_RELOCATABLE
 /*
  * Find the address of the relocations.
  */
-- 
1.7.0.4

