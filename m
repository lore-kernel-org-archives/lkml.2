Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0EMIst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 04:48:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab0EMIsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 04:48:47 -0400
Date: Thu, 13 May 2010 11:44:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] last minute vhost-net fix
Message-ID: <20100513084433.GA23082@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, if it's not too late, please pull the following
last minute fix into 2.6.34.
Thanks!

The following changes since commit de02d72bb3cc5b3d4c873db4ca8291723dd48479:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6 (2010-05-10 22:53:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git net-2.6

Michael S. Tsirkin (1):
      vhost: fix barrier pairing

 drivers/vhost/vhost.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

-- 
MST
