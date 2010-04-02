Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0DBSdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:33:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:57257 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0DBSdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:33:03 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb fixes for 2.6.34-rc3
Date: Fri,  2 Apr 2010 13:32:20 -0500
Message-Id: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 02 Apr 2010 18:32:42.0053 (UTC) FILETIME=[E14E1750:01CAD292]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kgdb-fixes for 2.6.34.  

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kgdb-fixes

Summary:
  * These are all the fixes that were specifically for the kgdb core from
    the original 2.6.34 merge window request.
  * Given where we are at in the rc cycle I removed the directory
    restructuring patch and this is bug fixes only.

Thanks,
Jason.


---
The following changes since commit 42be79e37e264557f12860fa4cc84b4de3685954:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kgdb-fixes

Jason Wessel (5):
      kgdb: have ebin2mem call probe_kernel_write once
      kgdbts,sh: Add in breakpoint pc offset for superh
      kgdb: eliminate kgdb_wait(), all cpus enter the same way
      kgdb: Use atomic operators which use barriers
      kgdb: Turn off tracing while in the debugger

 drivers/misc/kgdbts.c |    6 ++
 kernel/kgdb.c         |  209 +++++++++++++++++++++++++------------------------
 2 files changed, 111 insertions(+), 104 deletions(-)
