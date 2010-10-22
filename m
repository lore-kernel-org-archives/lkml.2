Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0JVGrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 02:47:23 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30930 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0JVGrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 02:47:22 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Oct 2010 09:47:10 +0300
Message-Id: <20101022064710.1687.65936.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.37
X-OriginalArrivalTime: 22 Oct 2010 06:46:29.0310 (UTC) FILETIME=[DB09DDE0:01CB71B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please, pull the UBIFS tree.

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (17):
      UBIFS: switch to RO mode after synchronizing
      UBIFS: do not treat ENOSPC specially
      UBIFS: fix assertion warning
      UBIFS: do not look up truncation nodes
      UBIFS: do not use key type in list_sort
      UBIFS: improve assertion in node comparison functions
      UBIFS: do not write rubbish into truncation scanning node
      UBIFS: mark unused key objects as invalid
      UBIFS: fix assertion warnings in comparison function
      UBIFS: introduce list sorting debugging checks
      UBIFS: improve error reporting when reading bad node
      UBIFS: introduce new flag for RO due to errors
      UBIFS: introduce new flags for RO mounts
      UBIFS: add a commentary about log recovery
      UBIFS: remove a bit of unneeded code
      UBIFS: do not forget to cancel timers
      UBIFS: do not allocate unneeded scan buffer

Steffen Sledz (1):
      UBIFS: avoid kernel error if ubifs superblock read fails

Vasiliy Kulikov (2):
      UBIFS: check return code of ubifs_lpt_lookup
      UBIFS: check return code of pnode_lookup

 fs/ubifs/commit.c     |    4 +-
 fs/ubifs/debug.c      |  156 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/debug.h      |    4 +
 fs/ubifs/file.c       |    7 +-
 fs/ubifs/gc.c         |   82 +++++++++++++++++++-------
 fs/ubifs/io.c         |   20 ++++---
 fs/ubifs/journal.c    |    3 +-
 fs/ubifs/key.h        |   14 +++++
 fs/ubifs/log.c        |    6 +-
 fs/ubifs/lpt.c        |    7 ++-
 fs/ubifs/lpt_commit.c |    3 +
 fs/ubifs/master.c     |    3 +-
 fs/ubifs/misc.h       |    9 ++-
 fs/ubifs/recovery.c   |   11 ++--
 fs/ubifs/replay.c     |   20 ++----
 fs/ubifs/sb.c         |    9 +--
 fs/ubifs/scan.c       |    6 +-
 fs/ubifs/shrinker.c   |    2 +-
 fs/ubifs/super.c      |   80 ++++++++++++++-----------
 fs/ubifs/tnc.c        |    5 +-
 fs/ubifs/ubifs.h      |   23 +++++--
 21 files changed, 362 insertions(+), 112 deletions(-)

Thanks,
Artem.
