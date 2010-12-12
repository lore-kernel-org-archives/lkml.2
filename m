Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0LLKKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 05:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab0LLKKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 05:10:39 -0500
Date: Sun, 12 Dec 2010 12:09:43 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [GIT PULL net-2.6] vhost-net: logging fixup
Message-ID: <20101212100943.GA12725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please merge the following fix for 2.6.37.
It is also applicable to -stable.
Thanks!

The following changes since commit a19faf0250e09b16cac169354126404bc8aa342b:

  net: fix skb_defer_rx_timestamp() (2010-12-10 16:20:56 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Michael S. Tsirkin (1):
      vhost: correctly set bits of dirty pages

 drivers/vhost/vhost.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
