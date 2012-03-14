Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031029Ab2CNSO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:14:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48311 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030974Ab2CNSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:14:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: JBeulich@suse.com, linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] minor fixes to xen-blkback (v1).
Date: Wed, 14 Mar 2012 14:10:29 -0400
Message-Id: <1331748631-4022-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090208.4F60E012.0086,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the patches I had already posted - just redid it per Jan's suggestion.
The other patch is based on Jan suggestion.

If there are no conerns I have put them in the usual branch:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.4

and will send out shortly a git pull.

 drivers/block/xen-blkback/blkback.c |   19 +++-----
 drivers/block/xen-blkback/common.h  |    6 ---
 drivers/block/xen-blkback/xenbus.c  |   83 +++++++++++++---------------------
 3 files changed, 40 insertions(+), 68 deletions(-)

