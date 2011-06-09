Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1FIQkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:40:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40322 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1FIQk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:40:26 -0400
Date: Thu, 9 Jun 2011 12:39:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: [GIT PULL] (swiotlb-2.6) stable/xen-swiotlb.bugfix for 3.0-rcX
Message-ID: <20110609163957.GA31709@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DF0F773.0040:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following git tree

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git stable/xen-swiotlb.bugfix

which has one patch since git tag v2.6.37. The bugfix is that the 'swiotlb'
command line argument was being ignored by Xen-SWIOTLB - this is now fixed.

FUJITA Tomonori (1):
      swiotlb: Export swioltb_nr_tbl and utilize it as appropiate.

 drivers/xen/swiotlb-xen.c |   12 +++++++++---
 include/linux/swiotlb.h   |    1 +
 lib/swiotlb.c             |    5 +++++
 3 files changed, 15 insertions(+), 3 deletions(-)
