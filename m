Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab1CXOf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:35:56 -0400
Received: from smtp.nokia.com ([147.243.1.48]:24353 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab1CXOfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:35:55 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 24 Mar 2011 16:38:35 +0200
Message-Id: <20110324143835.29758.362.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] More UBI/UBIFS changes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I've found a couple of brown-paperbag bugs in my changes which
you have merged this merge window. Also, we've fixed one UBIFS
assertion warning and I forgot to kill one Kconfig option.

So I've composed another UBI/UBIFS pull request where I address
the issues introduced in the previous pull request. I did not find
better way than to base the pull request on top of a "random"
current commit, hopefully this is acceptable. Yes, I tested the
patches with 2.6.38 release, not this commit.

Please, pull.

The following changes since commit 4bbba111d94781d34081c37856bbc5eb33f6c72a:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-03-23 07:58:09 -0700)

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git for-linus

Artem Bityutskiy (4):
      UBI: use GFP_NOFS properly
      UBIFS: use GFP_NOFS properly
      UBIFS: kill CONFIG_UBIFS_FS_DEBUG_CHKS
      UBIFS: fix assertion warning and refine comments

 drivers/mtd/ubi/io.c  |    4 ++--
 fs/ubifs/Kconfig      |    9 ---------
 fs/ubifs/debug.c      |    2 +-
 fs/ubifs/file.c       |   11 +++++++----
 fs/ubifs/lprops.c     |    2 +-
 fs/ubifs/lpt_commit.c |    4 ++--
 fs/ubifs/orphan.c     |    2 +-
 7 files changed, 14 insertions(+), 20 deletions(-)


Thanks,
Artem.
