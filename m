Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1LSRjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:39:11 -0500
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:55702 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751172Ab1LSRjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:39:09 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 19 Dec 2011 09:39:00 -0800
Message-Id: <1324316340-29223-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few last fixes:

 - Fix for crash on mlx4 module unload
 - Fix for crash on too-long private data in RDMA CM
 - Trivial fix for context counting bug in qib

Thanks!

Mike Marciniszyn (1):
      IB/qib: Correct sense on freectxts increment and decrement

Roland Dreier (2):
      IB/mlx4: Fix shutdown crash accessing a non-existent bitmap
      Merge branches 'cma', 'mlx4' and 'qib' into for-next

Sean Hefty (1):
      RDMA/cma: Verify private data length

 drivers/infiniband/core/cma.c            |    6 ++++++
 drivers/infiniband/hw/mlx4/main.c        |    6 ++++--
 drivers/infiniband/hw/qib/qib_file_ops.c |    4 ++--
 3 files changed, 12 insertions(+), 4 deletions(-)
