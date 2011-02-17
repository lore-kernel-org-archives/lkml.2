Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1BQW0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:26:32 -0500
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:37585 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753176Ab1BQW02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:26:28 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 17 Feb 2011 14:26:15 -0800
Message-Id: <1297981575-17431-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few small things:
 - Don't send events for nonexistent nes devices
 - Fix a couple of double events in qib

Maciej Sosnowski (1):
      RDMA/nes: Don't generate async events for unregistered devices

Mike Marciniszyn (2):
      IB/qib: Fix double add_timer()
      IB/qib: Prevent double completions after a timeout or RNR error

Roland Dreier (1):
      Merge branches 'nes' and 'qib' into for-next

 drivers/infiniband/hw/nes/nes_hw.c |   32 ++++++++++++++++++++------------
 drivers/infiniband/hw/qib/qib_rc.c |    5 ++++-
 2 files changed, 24 insertions(+), 13 deletions(-)
