Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0HCJJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:09:08 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47888 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0HCJJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:09:06 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Aug 2010 12:08:13 +0300
Message-Id: <20100803090813.13858.18589.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.36
X-OriginalArrivalTime: 03 Aug 2010 09:08:10.0762 (UTC) FILETIME=[65407EA0:01CB32EB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please, pull the UBIFS tree from:

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (2):
      UBIFS: check return code
      UBIFS: fix GC LEB recovery

Julia Lawall (1):
      UBIFS: use ERR_CAST

Matthieu CASTET (1):
      UBIFS: fix a memory leak on error path.

 fs/ubifs/lpt.c        |   14 +++++++-------
 fs/ubifs/lpt_commit.c |    2 +-
 fs/ubifs/recovery.c   |   23 ++++++++++++++++++-----
 fs/ubifs/super.c      |    4 +++-
 4 files changed, 29 insertions(+), 14 deletions(-)

Thanks,
Artem.
