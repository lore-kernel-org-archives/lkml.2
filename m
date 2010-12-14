Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0LNHWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 02:22:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:42575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0LNHW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 02:22:29 -0500
Date: Tue, 14 Dec 2010 18:22:17 +1100
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md bug fixes
Message-ID: <20101214182217.484f280a@notabene.brown>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Linus,
 here are a few bug fixes for md.
 Some of the patches are actually clean-up rather than bug-fix,
 but I that make the bugfix simpler to review.

Thanks,
NeilBrown


The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e83937b6:

  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-12-08 06:40:59 -0800)

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (5):
      md: remove handling of flush_pending in md_submit_flush_data
      md: move code in to submit_flushes.
      md: fix possible deadlock in handling flush requests.
      md: fix bug with re-adding of partially recovered device.
      md: protect against NULL reference when waiting to start a raid10.

 drivers/md/md.c     |   39 ++++++++++++++++++++-------------------
 drivers/md/raid10.c |    2 +-
 2 files changed, 21 insertions(+), 20 deletions(-)
