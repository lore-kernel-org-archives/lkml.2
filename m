Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2CDSfF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:35:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47103 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab2CDSfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:35:03 -0500
Date: Sun, 4 Mar 2012 13:31:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.4 for linux-block.git tree for
 3.4 (don't see a branch though?)
Message-ID: <20120304183109.GB449@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F53B5CD.00A5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please git pull the following branch in your 3.4 tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.4

or the following git tag:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.4-tag

which makes the block backend able to work under an HVM domain (by default it was only
working in PV), and some fixes and an performance improvement.

Please pull!

 drivers/block/xen-blkback/blkback.c |   31 ++++----------------------
 drivers/block/xen-blkfront.c        |   41 +++++++++++++++++------------------
 2 files changed, 25 insertions(+), 47 deletions(-)

Akinobu Mita (1):
      xen-blkfront: use bitmap_set() and bitmap_clear()

Andrew Jones (1):
      xen/blkfront: don't put bdev right after getting it

Daniel De Graaf (2):
      xen/blkback: use grant-table.c hypercall wrappers
      xen/blkback: Enable blkback on HVM guests

Steven Noonan (1):
      xen-blkfront: make blkif_io_lock spinlock per-device

