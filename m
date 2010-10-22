Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab0JVPwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 11:52:34 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52064 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab0JVPwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 11:52:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] DRBD updates for your for-2.6.37/drivers branch
Date: Fri, 22 Oct 2010 17:52:31 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221752.31480.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6362beea8914cbd4630ccde3617d944aeca2d48f:
  Mike Miller (1):
        cciss: fix PCI IDs for new Smart Array controllers

are available in the git repository at:

  git://git.drbd.org/linux-2.6-drbd.git for-jens

Lars Ellenberg (6):
      drbd: consolidate explicit drbd_md_sync into drbd_create_new_uuid
      drbd: tag a few error messages with "assert failed"
      drbd: fix potential deadlock on detach
      drbd: fix potential data divergence after multiple failures
      drbd: fix a misleading printk
      drbd: rate limit an error message

Philipp Reisner (1):
      drbd: Silenced an assert

 drivers/block/drbd/drbd_actlog.c   |   26 ++++++--
 drivers/block/drbd/drbd_int.h      |   30 +++++---
 drivers/block/drbd/drbd_main.c     |  141 +++++++++++++++++++++---------------
 drivers/block/drbd/drbd_nl.c       |   17 ++++-
 drivers/block/drbd/drbd_receiver.c |    5 +-
 drivers/block/drbd/drbd_req.c      |   24 +++++--
 drivers/block/drbd/drbd_worker.c   |    2 +-
 include/linux/drbd.h               |    2 +-
 8 files changed, 162 insertions(+), 85 deletions(-)
