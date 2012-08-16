Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab2HPP2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:28:30 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:47461 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2HPP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:28:29 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: drbd fixes
Date: Thu, 16 Aug 2012 17:28:26 +0200
Message-ID: <4092615.Zqxn9JocAf@fat-tyre>
User-Agent: KMail/4.8.4 (Linux/3.2.0-27-generic; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please consider to pull these 3 fixes in for 3.6.

Best,
 Phil

The following changes since commit a73ff3231df59a4b92ccd0dd4e73897c5822489b:

  drbd: announce FLUSH/FUA capability to upper layers (2012-07-24 15:14:28 +0200)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens

for you to fetch changes up to d1aa4d04da8de5c89d73859e077d89c4c71d8ed1:

  drbd: Write all pages of the bitmap after an online resize (2012-08-16 17:17:35 +0200)

----------------------------------------------------------------
Lars Ellenberg (1):
      drbd: fix drbd wire compatibility for empty flushes

Philipp Reisner (2):
      drbd: Finish requests that completed while IO was frozen
      drbd: Write all pages of the bitmap after an online resize

 drivers/block/drbd/drbd_bitmap.c |   15 ++++++++++++++-
 drivers/block/drbd/drbd_int.h    |    1 +
 drivers/block/drbd/drbd_main.c   |   28 ++++++++++++----------------
 drivers/block/drbd/drbd_nl.c     |    4 ++--
 drivers/block/drbd/drbd_req.c    |   36 ++++++++++++++++++++++++++++++++----
 5 files changed, 61 insertions(+), 23 deletions(-)

