Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0GAQqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:46:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0GAQqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:46:40 -0400
Date: Thu, 1 Jul 2010 19:41:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, krkumar2@in.ibm.com
Subject: [GIT PULL net-2.6] vhost-net: more error handling fixes
Message-ID: <20100701164127.GA3199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
The following tree includes more fixes dealing with
error handling in vhost-net. It is on top of net-2.6.
Please merge it for 2.6.35.
Thanks!

The following changes since commit 38000a94a902e94ca8b5498f7871c6316de8957a:

  sky2: enable rx/tx in sky2_phy_reinit() (2010-06-23 14:37:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Michael S. Tsirkin (2):
      vhost: break out of polling loop on error
      vhost: add unlikely annotations to error path

 drivers/vhost/net.c   |   12 ++++++-
 drivers/vhost/vhost.c |   86 +++++++++++++++++++++++++------------------------
 drivers/vhost/vhost.h |    8 ++--
 3 files changed, 58 insertions(+), 48 deletions(-)
-- 
MST
