Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2IGQDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:03:19 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29883 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2IGQDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:03:18 -0400
Date: Fri, 7 Sep 2012 11:52:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-jens-3.7
Message-ID: <20120907155237.GB6059@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please pull for your 3.7 tree the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.7

Which has two little fixes that are quite innocuous. Please pull.


 drivers/block/xen-blkback/xenbus.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

Konrad Rzeszutek Wilk (1):
      xen/blkback: Fix compile warning

Wei Yongjun (1):
      xen/blkback: use kmem_cache_zalloc instead of kmem_cache_alloc/memset

