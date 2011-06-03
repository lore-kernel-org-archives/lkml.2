Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1FCPSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:18:21 -0400
Received: from smtp.nokia.com ([147.243.1.47]:51863 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1FCPST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:18:19 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Jun 2011 18:22:10 +0300
Message-Id: <20110603152210.8652.58970.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for Linux 3.0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS fixex

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (7):
      UBIFS: supress false error messages
      UBIFS: introduce a "grouped" journal head flag
      UBIFS: amend ubifs_recover_leb interface
      UBIFS: fix recovery broken by the previous recovery fix
      UBIFS: fix shrinker object count reports
      UBIFS: fix memory leak on error path
      UBIFS: fix clean znode counter corruption in error cases

Ben Gardiner (3):
      UBIFS: assert no fixup when writing a node
      UBIFS: intialize LPT earlier
      UBIFS: fix-up free space earlier

 fs/ubifs/io.c       |    2 +
 fs/ubifs/journal.c  |    1 +
 fs/ubifs/orphan.c   |    2 +-
 fs/ubifs/recovery.c |  164 +++++++++++++++++++++++++++++----------------------
 fs/ubifs/replay.c   |    3 +-
 fs/ubifs/shrinker.c |    6 ++-
 fs/ubifs/super.c    |   42 ++++++++------
 fs/ubifs/tnc.c      |    9 ++-
 fs/ubifs/ubifs.h    |    4 +-
 9 files changed, 136 insertions(+), 97 deletions(-)

Thanks,
Artem.
