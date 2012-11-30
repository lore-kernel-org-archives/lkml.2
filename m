Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2K3WHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:07:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47268 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2K3WG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:06:59 -0500
Date: Fri, 30 Nov 2012 17:06:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.8 bug-fixes..
Message-ID: <20121130220649.GA1893@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens

Please git pull the following branch

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8

which has one cleanup and one tiny fix.

Please pull!

Roger Pau Monne (2):
      xen-blkback: move free persistent grants code
      xen-blkfront: free allocated page

 drivers/block/xen-blkback/blkback.c | 68 ++++++++++++++++++++-----------------
 drivers/block/xen-blkfront.c        |  1 +
 2 files changed, 38 insertions(+), 31 deletions(-)
