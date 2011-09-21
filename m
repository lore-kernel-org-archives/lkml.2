Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1IUPKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:10:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26576 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1IUPKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:10:03 -0400
Date: Wed, 21 Sep 2011 11:09:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: lidongyang@novell.com, joe.jin@oracle.com
Subject: [GIT PULL] (xen) stable/for-jens-3.2 - blkback and blkfront patches
 for 3.2
Message-ID: <20110921150955.GH541@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4E79FE47.0167,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please pull the following git tree in your 3.2 drivers tree:

 git pull git://oss.oracle.com/git/kwilk/xen.git stable/for-jens-3.2

which has an exciting new feature - the discard ('feature-discard')
aka TRIM/UNMAP. Now they can be passed from the guest to the backend.

There is also a tiny cleanup patch.

 drivers/block/xen-blkback/blkback.c |   86 +++++++++++++++++++++++-----
 drivers/block/xen-blkback/common.h  |   95 ++++++++++++++++++++++++------
 drivers/block/xen-blkback/xenbus.c  |   62 +++++++++++++++++++-
 drivers/block/xen-blkfront.c        |  109 +++++++++++++++++++++++++++-------
 include/xen/interface/io/blkif.h    |   36 ++++++++++++
 5 files changed, 331 insertions(+), 57 deletions(-)

Joe Jin (1):
      xen-blkback: fixed indentation and comments

Li Dongyang (4):
      xen-blkfront: add BLKIF_OP_DISCARD and discard request struct
      xen-blkback: Implement discard requests ('feature-discard')
      xen-blkfront: Handle discard requests.
      xen-blkfront: fix a deadlock while handling discard response

