Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0EDLYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:24:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab0EDLYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:24:52 -0400
Date: Tue, 4 May 2010 14:21:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] amended: first round of vhost-net enhancements for
	net-next
Message-ID: <20100504112100.GA22172@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
This is an amended pull request: I have rebased the tree to the
correct patches. This has been through basic tests and seems
to work fine here.

The following tree includes a couple of enhancements that help vhost-net.
Please pull them for net-next. Another set of patches is under
debugging/testing and I hope to get them ready in time for 2.6.35,
so there may be another pull request later.

Thanks!

The following changes since commit 7ef527377b88ff05fb122a47619ea506c631c914:

  Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6 (2010-05-02 22:02:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost

Michael S. Tsirkin (2):
      tun: add ioctl to modify vnet header size
      macvtap: add ioctl to modify vnet header size

 drivers/net/macvtap.c  |   27 +++++++++++++++++++++++----
 drivers/net/tun.c      |   32 ++++++++++++++++++++++++++++----
 include/linux/if_tun.h |    2 ++
 3 files changed, 53 insertions(+), 8 deletions(-)

-- 
MST
