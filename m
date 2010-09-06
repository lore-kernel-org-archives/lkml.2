Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0IFLmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:42:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab0IFLmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:42:14 -0400
Date: Mon, 6 Sep 2010 14:36:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL net-2.6] vhost-net: 2.6.36 regression fixes
Message-ID: <20100906113606.GA16143@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
The following tree includes more regression fixes for vhost-net
in 2.6.36.  It is on top of net-2.6.
Please merge it for 2.6.36.
Thanks!

The following changes since commit 0b5d404e349c0236b11466c0a4785520c0be6982:

  pkt_sched: Fix lockdep warning on est_tree_lock in gen_estimator (2010-09-02 13:22:11 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Michael S. Tsirkin (3):
      cgroups: fix API thinko
      vhost: fix attach to cgroups regression
      vhost: error handling fix

 drivers/vhost/vhost.c  |   80 ++++++++++++++++++++++++++++++++++-------------
 include/linux/cgroup.h |   11 ++++++-
 kernel/cgroup.c        |    9 +++--
 3 files changed, 73 insertions(+), 27 deletions(-)
-- 
MST
