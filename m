Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1CYVpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:45:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:33731 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1CYVpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:45:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb/kdb tree for 2.6.39-rc1
Date: Fri, 25 Mar 2011 16:44:16 -0500
Message-Id: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 25 Mar 2011 21:44:20.0973 (UTC) FILETIME=[CCAAC9D0:01CBEB35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch to pick up the minor clean ups
for kgdb for 2.6.39.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Thanks,
Jason.

---
The following changes since commit 4bbba111d94781d34081c37856bbc5eb33f6c72a:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-03-23 07:58:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Dan Carpenter (1):
      kgdboc,kgdbts: strlen() doesn't count the terminator

Jason Wessel (1):
      kgdb,x86_64: fix compile warning found with sparse

Jovi Zhang (1):
      kdb: code cleanup to use macro instead of value

Namhyung Kim (1):
      kdb: add usage string of 'per_cpu' command

 arch/x86/kernel/kgdb.c      |    4 ++--
 drivers/misc/kgdbts.c       |    2 +-
 drivers/tty/serial/kgdboc.c |    2 +-
 kernel/debug/kdb/kdb_main.c |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)
