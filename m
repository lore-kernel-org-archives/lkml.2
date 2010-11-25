Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0KYQfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:35:07 -0500
Received: from mail09.linbit.com ([212.69.161.110]:49842 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab0KYQfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:35:05 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <jaxboe@fusionio.com>
Subject: [GIT PULL] Regression fixes for DRBD
Date: Thu, 25 Nov 2010 17:35:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011251735.02696.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please pull these two fixes for regressions.

One significant performance regression (more than factor 10 for a 
special workload), and a locking regression.

Those two should go in before 2.6.37, I based it on your for-linus
branch.


The following changes since commit bbe425cd9ae83eacd0c9f09df2bf56dc911a54cd:

  cciss: fix build for PROC_FS disabled (2010-11-17 11:56:13 +0100)

are available in the git repository at:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

Lars Ellenberg (2):
      drbd: don't recvmsg with zero length
      drbd: fix for spin_lock_irqsave in endio callback

 drivers/block/drbd/drbd_receiver.c |   14 ++++++++------
 drivers/block/drbd/drbd_req.h      |    3 ++-
 drivers/block/drbd/drbd_worker.c   |   10 +++++++++-
 3 files changed, 19 insertions(+), 8 deletions(-)

Best,
 Phil
