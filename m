Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0ITRs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:48:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab0ITRs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:48:28 -0400
Date: Mon, 20 Sep 2010 19:42:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL net-2.6] vhost-net: fix range checking
Message-ID: <20100920174222.GA30510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
The following tree includes a bugfix for vhost-net.
It is on top of net-2.6.  Please merge it for 2.6.36.
Thanks!

The following changes since commit 053d8f6622701f849fda2ca2c9ae596c13599ba9:

  Merge branch 'vhost-net' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost (2010-09-09 21:59:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Michael S. Tsirkin (1):
      vhost-net: fix range checking in mrg bufs case

 drivers/vhost/net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
