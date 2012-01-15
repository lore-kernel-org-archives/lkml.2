Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab2AOMCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:02:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38656 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2AOMCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:02:50 -0500
From: xiyou.wangcong@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [Patch] x86: add arch/x86/tools/insn_sanity to .gitignore
Date: Sun, 15 Jan 2012 20:02:17 +0800
Message-Id: <1326628937-27609-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After compiling kernel, I got:

	% git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	arch/x86/tools/insn_sanity
	nothing added to commit but untracked files present (use "git add" to track)

it should be added to .gitignore.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/x86/.gitignore b/arch/x86/.gitignore
index 0280790..7cab8c0 100644
--- a/arch/x86/.gitignore
+++ b/arch/x86/.gitignore
@@ -1,3 +1,4 @@
 boot/compressed/vmlinux
 tools/test_get_len
+tools/insn_sanity
 
