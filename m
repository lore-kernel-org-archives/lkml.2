Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1CYTH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:07:29 -0400
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:32822 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752359Ab1CYTH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:07:28 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 25 Mar 2011 12:07:09 -0700
Message-Id: <1301080029-19082-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get one fix for a bug introduced into the nes driver through
the net tree:

Roland Dreier (1):
      RDMA/nes: Fix test of uninitialized netdev

 drivers/infiniband/hw/nes/nes_cm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
