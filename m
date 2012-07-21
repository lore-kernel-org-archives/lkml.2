Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2GUW5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 18:57:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab2GUW5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 18:57:19 -0400
Date: Sun, 22 Jul 2012 01:54:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: asias@redhat.com, mst@redhat.com, nab@linux-iscsi.org,
        nab@risingtidesystems.com, pbonzini@redhat.com, stefanha@gmail.com,
        stefanha@linux.vnet.ibm.com, wuzhy@cn.ibm.com
Subject: [PULL] vhost-net changes for net/3.6
Message-ID: <20120721225436.GA23519@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
Please merge the following patches into net tree for 3.6.
They are on top of the current net-next.
Thanks!


The following changes since commit 186e868786f97c8026f0a81400b451ace306b3a4:

  forcedeth: spin_unlock_irq in interrupt handler fix (2012-07-20 16:18:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net-next

for you to fetch changes up to 163049aefdc04323a2d17ec9f2862027b43b0502:

  vhost: make vhost work queue visible (2012-07-22 01:22:23 +0300)

----------------------------------------------------------------
Stefan Hajnoczi (2):
      vhost: Separate vhost-net features from vhost features
      vhost: make vhost work queue visible

 drivers/vhost/net.c   | 4 ++--
 drivers/vhost/test.c  | 4 ++--
 drivers/vhost/vhost.c | 5 ++---
 drivers/vhost/vhost.h | 6 +++++-
 4 files changed, 11 insertions(+), 8 deletions(-)
