Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2APJD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:03:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2APJD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:03:26 -0500
Date: Mon, 16 Jan 2012 01:03:03 -0800
From: "tip-bot for xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Message-ID: <tip-a1c611745c8c4e8996c1877d4e5d0fc95f227c38@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu,
        xiyou.wangcong@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        xiyou.wangcong@gmail.com, mingo@elte.hu
In-Reply-To: <1326628937-27609-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1326628937-27609-1-git-send-email-xiyou.wangcong@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86/kprobes: Add arch/x86/tools/insn_sanity to .
 gitignore
Git-Commit-ID: a1c611745c8c4e8996c1877d4e5d0fc95f227c38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Jan 2012 01:03:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1c611745c8c4e8996c1877d4e5d0fc95f227c38
Gitweb:     http://git.kernel.org/tip/a1c611745c8c4e8996c1877d4e5d0fc95f227c38
Author:     xiyou.wangcong@gmail.com <xiyou.wangcong@gmail.com>
AuthorDate: Sun, 15 Jan 2012 20:02:17 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Jan 2012 08:21:59 +0100

x86/kprobes: Add arch/x86/tools/insn_sanity to .gitignore

After compiling the kernel, I got:

	% git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	arch/x86/tools/insn_sanity
	nothing added to commit but untracked files present (use "git add" to track)

it should be added to .gitignore.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1326628937-27609-1-git-send-email-xiyou.wangcong@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/.gitignore b/arch/x86/.gitignore
index 0280790..7cab8c0 100644
--- a/arch/x86/.gitignore
+++ b/arch/x86/.gitignore
@@ -1,3 +1,4 @@
 boot/compressed/vmlinux
 tools/test_get_len
+tools/insn_sanity
 
