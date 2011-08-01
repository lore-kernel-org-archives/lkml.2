Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1HATBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:01:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:50465 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1HATBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:01:43 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [GIT PULL] kgdb/kdb updates for 3.1 
Date: Mon, 1 Aug 2011 14:00:56 -0500
Message-ID: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch to pick up the minor kgdb/kdb
cleanups accumulated in the last few months.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Thanks,
Jason.

---

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Jason Wessel (4):
      kdb: cleanup unused variables missed in the original kdb merge
      kdb,kgdb: Implement switch and pass buffer from kdb -> gdb
      kdb: Remove all references to DOING_KGDB2
      kdb,kgdb: Allow arbitrary kgdb magic knock sequences

 kernel/debug/gdbstub.c          |   22 +++++++++++++++-------
 kernel/debug/kdb/kdb_bt.c       |    5 ++---
 kernel/debug/kdb/kdb_cmds       |    4 ----
 kernel/debug/kdb/kdb_debugger.c |   21 ++++++++-------------
 kernel/debug/kdb/kdb_io.c       |   36 +++++++++++++++++++++++++-----------
 kernel/debug/kdb/kdb_main.c     |    4 ++--
 kernel/debug/kdb/kdb_private.h  |    3 +--
 7 files changed, 53 insertions(+), 42 deletions(-)
