Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0JSPF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab0JSPF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:05:58 -0400
Date: Tue, 19 Oct 2010 16:59:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL net-2.6] vhost-net: access_ok fix
Message-ID: <20101019145901.GA16025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
Not sure if it's too late for 2.6.36 - in case it's not, the following tree
includes a last minute bugfix for vhost-net, found by code inspection.
It is on top of net-2.6.
Thanks!

The following changes since commit b0057c51db66c5f0f38059f242c57d61c4741d89:

  tg3: restore rx_dropped accounting (2010-10-11 16:06:24 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Dan Carpenter (1):
      vhost: fix return code for log_access_ok()

 drivers/vhost/vhost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
MST
