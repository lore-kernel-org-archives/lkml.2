Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423796Ab2LFPPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:15:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423775Ab2LFPO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:14:59 -0500
Date: Thu, 6 Dec 2012 17:18:00 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinggnu@gmail.com, mst@redhat.com,
        yongjun_wei@trendmicro.com.cn
Subject: [PULL net-next] vhost: changes for 3.8
Message-ID: <20121206151800.GA3889@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b93196dc5af7729ff7cc50d3d322ab1a364aa14f:

  net: fix some compiler warning in net/core/neighbour.c (2012-12-05 21:50:37 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net-next

for you to fetch changes up to 405d55c99da7a3045275fdb1a30614293a53c6e7:

  tcm_vhost: remove unused variable in vhost_scsi_allocate_cmd() (2012-12-06 17:09:19 +0200)

----------------------------------------------------------------
Cong Ding (1):
      tools:virtio: fix compilation warning

Michael S. Tsirkin (4):
      vhost: avoid backend flush on vring ops
      vhost-net: flush outstanding DMAs on memory change
      vhost-net: skip head management if no outstanding
      vhost-net: enable zerocopy tx by default

Wei Yongjun (1):
      tcm_vhost: remove unused variable in vhost_scsi_allocate_cmd()

 drivers/vhost/net.c        | 51 ++++++++++++++++++++++++++++++----------------
 drivers/vhost/tcm_vhost.c  |  7 ++++---
 drivers/vhost/vhost.c      |  7 +++----
 drivers/vhost/vhost.h      |  3 ++-
 tools/virtio/virtio_test.c |  2 +-
 5 files changed, 44 insertions(+), 26 deletions(-)
