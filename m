Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291Ab1EARou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:44:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:32882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1EARor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:44:47 -0400
Date: Sun, 1 May 2011 17:44:27 GMT
From: tip-bot for Bart Van Assche <bvanassche@acm.org>
Message-ID: <tip-9de4966a4d218f29c68e96e8e7b4d2840dedec79@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bvanassche@acm.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <201105011409.21629.bvanassche@acm.org>
References: <201105011409.21629.bvanassche@acm.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Fix spelling error in the memcpy() source code comment
Git-Commit-ID: 9de4966a4d218f29c68e96e8e7b4d2840dedec79
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 01 May 2011 17:44:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9de4966a4d218f29c68e96e8e7b4d2840dedec79
Gitweb:     http://git.kernel.org/tip/9de4966a4d218f29c68e96e8e7b4d2840dedec79
Author:     Bart Van Assche <bvanassche@acm.org>
AuthorDate: Sun, 1 May 2011 14:09:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 1 May 2011 19:16:18 +0200

x86: Fix spelling error in the memcpy() source code comment

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/r/201105011409.21629.bvanassche@acm.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/memcpy_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..2a560bb 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -49,7 +49,7 @@ ENTRY(memcpy)
 	jb .Lhandle_tail
 
 	/*
-	 * We check whether memory false dependece could occur,
+	 * We check whether memory false dependence could occur,
 	 * then jump to corresponding copy mode.
 	 */
 	cmp  %dil, %sil
