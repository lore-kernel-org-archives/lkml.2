Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2FLQWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:22:07 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:41715 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2FLQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:22:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] drbd fixes
Date: Tue, 12 Jun 2012 18:22:03 +0000
Message-ID: <1788738.mNsnrf6o6T@fat-tyre>
Organization: LINBIT
User-Agent: KMail/4.8.3 (Linux/3.2.0-24-generic; KDE/4.8.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

In the last 4 weeks three bugs were reported and fixed. Please consider
to pass these 3 commits on to Linus.

The following changes since commit 4fd1ffaa122cf66bfb710ced43679413df4f3605:

  Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-3.5/drivers (2012-05-18 16:20:06 +0200)

are available in the git repository at:


  git://git.drbd.org/linux-drbd.git for-jens

for you to fetch changes up to 0d5934e3c258fc5decc4103600c597086fd95a52:

  drbd: fix null pointer dereference with on-congestion policy when diskless (2012-06-12 14:35:19 +0200)

----------------------------------------------------------------
Lars Ellenberg (3):
      drbd: fix access of unallocated pages and kernel panic
      drbd: fix list corruption by failing but already aborted reads
      drbd: fix null pointer dereference with on-congestion policy when diskless

 drivers/block/drbd/drbd_bitmap.c |   11 +++++--
 drivers/block/drbd/drbd_req.c    |   66 ++++++++++++++++++++++++--------------
2 files changed, 51 insertions(+), 26 deletions(-)

Best,
 Philipp
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

