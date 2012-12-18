Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2LRFP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:15:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22416 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2LRFP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:15:57 -0500
Date: Tue, 18 Dec 2012 00:15:47 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] Bug-fixes to xen-blkfront for v3.8
Message-ID: <20121218051547.GA13450@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8

which has a bug-fix to the xen-blkfront and xen-blkback driver
when using the persistent mode. An issue was discovered where LVM
disks could not be read correctly and this fixes it. There
is also a change in llist.h which has been blessed by akpm.

Please pull!

 drivers/block/xen-blkback/blkback.c | 18 +++++++++++-------
 drivers/block/xen-blkfront.c        | 10 ++++++----
 include/linux/llist.h               | 25 +++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 11 deletions(-)

Roger Pau Monne (3):
      xen-blkback: implement safe iterator for the list of persistent grants
      llist/xen-blkfront: implement safe version of llist_for_each_entry
      xen-blkfront: handle bvecs with partial data

