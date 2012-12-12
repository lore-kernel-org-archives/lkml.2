Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2LLECj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:02:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab2LLECi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:02:38 -0500
Message-ID: <1355284941.3224.196.camel@bling.home>
Subject: [GIT PULL v2] VFIO updates for v3.8
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        fengguang.wu@intel.com, julia.lawall@lip6.fr, jiang.liu@huawei.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 11 Dec 2012 21:02:21 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Take 2 using the same commits as in Stephen's next tree, please note the
new tag below.  There's a merge with v3.7 in my for-linus branch of the
below tree, not that you should need it.  Thanks,

Alex

The following changes since commit 1afa471706963643ceeda7cbbe9c605a1e883d53:

  Merge tag 'mmc-fixes-for-3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc (2012-12-07 09:15:20 -0800)

are available in the git repository at:


  git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.8-v2

for you to fetch changes up to 9a92c5091a42c565ede818fdf204c4f60004d0d8:

  vfio-pci: Enable device before attempting reset (2012-12-07 13:43:51 -0700)

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


