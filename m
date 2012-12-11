Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2LKTIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:08:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab2LKTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:08:23 -0500
Message-ID: <1355252887.3224.176.camel@bling.home>
Subject: [GIT PULL] VFIO updates for v3.8
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        fengguang.wu@intel.com, julia.lawall@lip6.fr, jiang.liu@huawei.com
Date: Tue, 11 Dec 2012 12:08:07 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 29594404d7fe73cd80eaa4ee8c43dcc53970c60e:

  Linux 3.7 (2012-12-10 19:30:57 -0800)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.8

for you to fetch changes up to a9e3ccfa452c8c5bac49637fe6ece1ac3246d312:

  vfio-pci: Enable device before attempting reset (2012-12-11 11:25:37 -0700)

----------------------------------------------------------------
vfio pull for v3.8

----------------------------------------------------------------
Alex Williamson (2):
      vfio-pci: Re-order device reset
      vfio-pci: Enable device before attempting reset

Fengguang Wu (1):
      vfio: simplify kmalloc+copy_from_user to memdup_user

Jiang Liu (3):
      VFIO: unregister IOMMU notifier on error recovery path
      VFIO: use ACCESS_ONCE() to guard access to dev->driver
      VFIO: fix out of order labels for error recovery in vfio_pci_init()

 drivers/vfio/pci/vfio_pci.c | 83 +++++++++++++++++++++++++--------------------
 drivers/vfio/vfio.c         | 34 +++++++++----------
 2 files changed, 64 insertions(+), 53 deletions(-)


