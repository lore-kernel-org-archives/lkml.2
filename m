Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2E1Dwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:52:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51909 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364Ab2E1D3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:10 -0400
Message-Id: <20120528031205.084222483@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Maxim Levitsky <maximlevitsky@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 016/117] mtd: sm_ftl: fix typo in major number.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit 452380efbd72d8d41f53ea64c8a6ea1fedc4394d upstream.

major == 0 allocates dynamic major, not major == -1

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/sm_ftl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
index 072ed59..9e2dfd5 100644
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -1256,7 +1256,7 @@ static void sm_remove_dev(struct mtd_blktrans_dev *dev)
 
 static struct mtd_blktrans_ops sm_ftl_ops = {
 	.name		= "smblk",
-	.major		= -1,
+	.major		= 0,
 	.part_bits	= SM_FTL_PARTN_BITS,
 	.blksize	= SM_SECTOR_SIZE,
 	.getgeo		= sm_getgeo,


