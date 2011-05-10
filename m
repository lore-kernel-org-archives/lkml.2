Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1EJRL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 13:11:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47290 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1EJRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 13:11:28 -0400
Date: Tue, 10 May 2011 13:11:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/blkfront for 2.6.40
Message-ID: <20110510171107.GA939@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DC971B4.0103:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please pull:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/blkfront

which has changes since git commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58
Linus Torvalds (1):
    Linux 2.6.39-rc5

The git commit includes a bug-fix, and a set of patches to allow the blkfront
driver to use 'feature-flush-cache' feature. The 'flush-cache' is basically
the equivalent of the new REQ_FLUSH command (the old 'feature-barrier' is
still present in the driver in case the backend supports that).

If you prefer for me to ask Linus to pull this git tree since it includes
a patch to the include/xen/interface/.. directory - I can do that as long as
you are OK with that.


Konrad Rzeszutek Wilk (2):
      xen-blkfront: Provide for 'feature-flush-cache' the BLKIF_OP_WRITE_FLUSH_CACHE operation.
      xen-blkfront: Introduce BLKIF_OP_FLUSH_DISKCACHE support.

Marek Marczykowski (1):
      xen-blkfront: fix data size for xenbus_gather in blkfront_connect


 drivers/block/xen-blkfront.c     |   51 +++++++++++++++++++++++++++----------
 include/xen/interface/io/blkif.h |   13 +++++++++
 2 files changed, 50 insertions(+), 14 deletions(-)


