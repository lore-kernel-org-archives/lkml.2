Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0KYMX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:23:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0KYMXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:23:54 -0500
Date: Thu, 25 Nov 2010 14:23:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL net-2.6] vhost-net: rcu fixup
Message-ID: <20101125122301.GA15990@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please merge the following fix for 2.6.36.
Thanks!

The following changes since commit a27e13d370415add3487949c60810e36069a23a6:

  econet: fix CVE-2010-3848 (2010-11-24 11:51:47 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Michael S. Tsirkin (1):
      vhost/net: fix rcu check usage

 drivers/vhost/net.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)
-- 
MST
