Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0JESds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:33:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab0JESdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:33:46 -0400
Date: Tue, 5 Oct 2010 20:27:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [GIT PULL net-next-2.6] vhost-net patchset for 2.6.37
Message-ID: <20101005182732.GA25796@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like it was a quiet cycle for vhost-net:
probably because most of energy was spent on bugfixes
that went in for 2.6.36.
People are working on multiqueue, tracing but I'm not
sure it'll get done in time for 2.6.37 - so here's
a tree with a single patch that helps windows guests
which we definitely want in the next kernel.

Please merge for 2.6.37.
Thanks!

The following changes since commit a00eac0c459abecb539fb2a2abd3122dd7ca5d4a:

  ppp: Use a real SKB control block in fragmentation engine. (2010-10-05 01:36:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net-next

Jason Wang (1):
      vhost: max s/g to match qemu

 drivers/vhost/net.c   |    2 +-
 drivers/vhost/vhost.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |   18 ++++++++----------
 3 files changed, 57 insertions(+), 12 deletions(-)
