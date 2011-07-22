Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1GVGcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:32:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab1GVGcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:32:20 -0400
Date: Fri, 22 Jul 2011 09:32:38 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mashirle@us.ibm.com, xma@us.ibm.com
Subject: [PULL net (try 2)] vhost-net: zercopy mode fixes
Message-ID: <20110722063238.GB9637@redhat.com>
References: <20110722060046.GA8876@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722060046.GA8876@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing a corrupted pull request sent earlier.
Sorry about the noise!

The following includes vhost-net fixes - both in the
experimental zero copy mode.
Please pull for 3.1.
Thanks!

The following changes since commit fd99beb9375b44309d5ed9c2b62063e23151610b:

  Merge branch 'vhost-net-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost (2011-07-19 10:12:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net-next

Michael S. Tsirkin (1):
      vhost-net: update used ring on backend change

Shirley Ma (1):
      vhost: handle wrap around in # of bufs math

 drivers/vhost/net.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)
