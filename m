Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab2ENEGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 00:06:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51855 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2ENEF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 00:05:59 -0400
Date: Mon, 14 May 2012 00:05:55 -0400 (EDT)
Message-Id: <20120514.000555.1842884084717866000.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 May 2012 21:05:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The main purpose of this pull request is to fix up the erroneous
bonding patch I applied last round.  I meant to apply v4 of the patch
from Jiri but I applied v3 by accident.  Mea culpa.

Also, eagle eyed Dan Carpenter noticed that openvswitch has one of
those "X = alloc(); if (!Y)" mistakes, test the proper pointer
instead.

Please pull, thanks a lot!

The following changes since commit cf00c55e3d30b242d6f6530e61a7bc828124f0a3:

  Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2012-05-12 13:02:31 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

for you to fetch changes up to 8aa51d64c1f526e43b1e7f89fb8b98c2fd583f4b:

  openvswitch: checking wrong variable in queue_userspace_packet() (2012-05-13 15:47:34 -0400)

----------------------------------------------------------------
Dan Carpenter (1):
      openvswitch: checking wrong variable in queue_userspace_packet()

David S. Miller (1):
      bonding: Fix LACPDU rx_dropped commit.

 drivers/net/bonding/bond_alb.c |   12 +++++++-----
 drivers/net/bonding/bonding.h  |    2 +-
 net/openvswitch/datapath.c     |    2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)
