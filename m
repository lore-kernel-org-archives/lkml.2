Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1F2Mkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:40:55 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:53613 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1F2Mkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:40:51 -0400
Date: Wed, 29 Jun 2011 14:40:50 +0200
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] xen/blkback: Add module alias for autoloading
Message-ID: <20110629124050.GC31038@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	xen-devel@lists.xensource.com,
	virtualization@lists.linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add xen-backend:vbd module alias to the xen-blkback module. This allows
automatic loading of the module.

Signed-off-by: Bastian Blank <waldi@debian.org>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 5cf2993..ed62008 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -824,3 +824,4 @@ static int __init xen_blkif_init(void)
 module_init(xen_blkif_init);
 
 MODULE_LICENSE("Dual BSD/GPL");
+MODULE_ALIAS("xen-backend:vbd");
-- 
1.7.5.4
