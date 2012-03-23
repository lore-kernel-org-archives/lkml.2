Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2CWQIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:08:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab2CWQID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:08:03 -0400
Date: Fri, 23 Mar 2012 17:28:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, levinsasha928@gmail.com, mst@redhat.com,
        nyh@il.ibm.com, nyh@math.technion.ac.il
Subject: [PULL net] vhost-net/virtio: fixes for 3.4
Message-ID: <20120323152807.GA6037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

The following changes since commit 5ffca28a4ac7abb8a254fafe6bd03b2f83667df7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs (2012-02-27 07:59:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

for you to fetch changes up to ea5d404655ba3b356d0c06d6a3c4f24112124522:

  vhost: fix release path lockdep checks (2012-02-28 09:13:22 +0200)

----------------------------------------------------------------
vhost/virtio: fixes for 3.4

This includes a couple of vhost-net bugfixes,
and fixes tools/virtio making it useful again.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (4):
      tools/virtio: add linux/module.h stub
      tools/virtio: add linux/hrtimer.h stub
      tools/virtio: stub out strong barriers
      vhost: fix release path lockdep checks

Nadav Har'El (1):
      vhost: don't forget to schedule()

 drivers/vhost/net.c         |    2 +-
 drivers/vhost/vhost.c       |   11 +++++++----
 drivers/vhost/vhost.h       |    2 +-
 tools/virtio/linux/virtio.h |    3 +++
 4 files changed, 12 insertions(+), 6 deletions(-)
 create mode 100644 tools/virtio/linux/hrtimer.h
 create mode 100644 tools/virtio/linux/module.h
