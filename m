Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1EBRDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:03:16 -0400
Received: from smtp.nokia.com ([147.243.1.48]:56239 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1EBRDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:03:15 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 02 May 2011 20:05:59 +0300
Message-Id: <20110502170559.14532.1878.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS recovery fixes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are 2 more UBIFS recovery failure fixes which I'd like to merge upstream and
to -stable. These patches fix the situation when UBIFS fails to mount the file-system
after a power cut. I've been testing the 2 patches extensively for a week, so I'm
quite confident they do not break anything and I cannot reproduce the mount failures
with them. Please, pull.

The following changes since commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58:

  Linux 2.6.39-rc5 (2011-04-26 20:48:50 -0700)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git for-linus

Artem Bityutskiy (2):
      UBIFS: do not free write-buffers when in R/O mode
      UBIFS: seek journal heads to the latest bud in replay

 fs/ubifs/log.c    |   20 --------------------
 fs/ubifs/replay.c |   18 ++++++++++++------
 fs/ubifs/super.c  |   15 ++++-----------
 3 files changed, 16 insertions(+), 37 deletions(-)

Thanks,
Artem.
