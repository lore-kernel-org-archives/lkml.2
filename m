Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1BAPp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:45:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab1BAPp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:45:26 -0500
Date: Tue, 1 Feb 2011 17:44:40 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL] vhost-net: 2.6.38 - warning fix
Message-ID: <20110201154440.GA22819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please merge for 2.6.38. Not the most elegant fix,
but it does fix the noise in dmesg that interferes with
kvm debugging, and probably the best we can do for 2.6.38.

The following changes since commit fca540ab5f4718c6133f71f7be1793066008bf89:

  enc28j60: Fix reading of transmit status vector (2011-01-31 20:56:54 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Michael S. Tsirkin (1):
      vhost: rcu annotation fixup

 drivers/vhost/net.c   |    9 +++++----
 drivers/vhost/vhost.h |    6 +++---
 2 files changed, 8 insertions(+), 7 deletions(-)
