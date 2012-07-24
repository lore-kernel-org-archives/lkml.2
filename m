Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2GXOYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:24:39 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:36357 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2GXOYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:24:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: drbd-8.3 fixes
Date: Tue, 24 Jul 2012 16:24:35 +0200
Message-ID: <6356994.vJFLSmzzfE@fat-tyre>
User-Agent: KMail/4.8.4 (Linux/3.2.0-26-generic; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please consider to pull these changes for the 3.6 merge window.
I did not found a for-3.6/drivers branch, so I based the patches
on the 3.5 release.

Best,
 Phil


The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens

for you to fetch changes up to a73ff3231df59a4b92ccd0dd4e73897c5822489b:

  drbd: announce FLUSH/FUA capability to upper layers (2012-07-24 15:14:28 +0200)

----------------------------------------------------------------
Lars Ellenberg (10):
      drbd: cleanup, remove two unused global flags
      drbd: differentiate between normal and forced detach
      drbd: report congestion if we are waiting for some userland callback
      drbd: reset congestion information before reporting it in /proc/drbd
      drbd: do not reset rs_pending_cnt too early
      drbd: call local-io-error handler early
      drbd: fix potential access after free
      drbd: flush drbd work queue before invalidate/invalidate remote                                 
      drbd: fix max_bio_size to be unsigned                                                           
      drbd: announce FLUSH/FUA capability to upper layers

 drivers/block/drbd/drbd_actlog.c   |    8 +++--
 drivers/block/drbd/drbd_bitmap.c   |    4 +--
 drivers/block/drbd/drbd_int.h      |   44 ++++++++++++++++--------
 drivers/block/drbd/drbd_main.c     |   65 +++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_nl.c       |   36 +++++++++++++++-----
 drivers/block/drbd/drbd_proc.c     |    3 ++
 drivers/block/drbd/drbd_receiver.c |   38 +++++++++++++++------
 drivers/block/drbd/drbd_req.c      |    9 +++--
 drivers/block/drbd/drbd_worker.c   |   12 ++-----
 9 files changed, 153 insertions(+), 66 deletions(-)


