Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab2JUSWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:22:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2JUSV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:21:59 -0400
Date: Sun, 21 Oct 2012 11:21:30 -0700
From: tip-bot for Jean Delvare <khali@linux-fr.org>
Message-ID: <tip-fd0587339d80dd2fea5ead7f734676c9c618eace@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rdunlap@xenotime.net, khali@linux-fr.org, fernando@oss.ntt.co.jp,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fernando@oss.ntt.co.jp, khali@linux-fr.org, tglx@linutronix.de,
        rdunlap@xenotime.net, dzickus@redhat.com
In-Reply-To: <20121021120551.4656d99b@endymion.delvare>
References: <20121021120551.4656d99b@endymion.delvare>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] Documentation:
  Reflect the new location of the NMI watchdog info
Git-Commit-ID: fd0587339d80dd2fea5ead7f734676c9c618eace
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 21 Oct 2012 11:21:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd0587339d80dd2fea5ead7f734676c9c618eace
Gitweb:     http://git.kernel.org/tip/fd0587339d80dd2fea5ead7f734676c9c618eace
Author:     Jean Delvare <khali@linux-fr.org>
AuthorDate: Sun, 21 Oct 2012 12:05:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Oct 2012 19:03:35 +0200

Documentation: Reflect the new location of the NMI watchdog info

Commit 9919cba7 ("watchdog: Update documentation") moved the
NMI watchdog documentation from nmi_watchdog.txt to
lockup-watchdogs.txt. Update the index file accordingly.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/20121021120551.4656d99b@endymion.delvare
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/00-INDEX |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 49c0513..fec55dc 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -210,6 +210,8 @@ local_ops.txt
 	- semantics and behavior of local atomic operations.
 lockdep-design.txt
 	- documentation on the runtime locking correctness validator.
+lockup-watchdogs.txt
+	- info on soft and hard lockup detectors (aka nmi_watchdog).
 logo.gif
 	- full colour GIF image of Linux logo (penguin - Tux).
 logo.txt
@@ -240,8 +242,6 @@ netlabel/
 	- directory with information on the NetLabel subsystem.
 networking/
 	- directory with info on various aspects of networking with Linux.
-nmi_watchdog.txt
-	- info on NMI watchdog for SMP systems.
 nommu-mmap.txt
 	- documentation about no-mmu memory mapping support.
 numastat.txt
