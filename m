Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0GVAhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:37:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:59976 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0GVAhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:37:12 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb regression fixes for 2.6.35-rc5
Date: Wed, 21 Jul 2010 19:36:10 -0500
Message-Id: <1279758975-16658-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 22 Jul 2010 00:36:23.0783 (UTC) FILETIME=[E9825770:01CB2935]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch for 2.6.35-rc5.  

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

The following patch set covers cleaning up problems that have been
found since the merge of kdb to the 2.6.35-rc1 kernel.

Thanks,
Jason.


---
Jason Wessel (4):
      repair gdbstub to match the gdbserial protocol specification
      Fix merge regression from external kdb to upstream kdb
      debug_core,kdb: fix kgdb_connected bit set in the wrong place
      sysrq,kdb: Use __handle_sysrq() for kdb's sysrq function

Martin Hicks (1):
      kdb: break out of kdb_ll() when command is terminated

 drivers/char/sysrq.c        |    2 +-
 include/linux/sysrq.h       |    1 +
 kernel/debug/debug_core.c   |    2 +-
 kernel/debug/gdbstub.c      |    9 +++------
 kernel/debug/kdb/kdb_main.c |    7 +++++--
 5 files changed, 11 insertions(+), 10 deletions(-)
