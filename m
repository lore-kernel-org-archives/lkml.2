Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2E0A63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:58:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2E0A6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:58:25 -0400
Message-Id: <20120527002616.567845529@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:31 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Maxim Levitsky <maximlevitsky@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 18/55] mtd: sm_ftl: fix typo in major number.
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit 452380efbd72d8d41f53ea64c8a6ea1fedc4394d upstream.

major == 0 allocates dynamic major, not major == -1

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/sm_ftl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -1256,7 +1256,7 @@ static void sm_remove_dev(struct mtd_blk
 
 static struct mtd_blktrans_ops sm_ftl_ops = {
 	.name		= "smblk",
-	.major		= -1,
+	.major		= 0,
 	.part_bits	= SM_FTL_PARTN_BITS,
 	.blksize	= SM_SECTOR_SIZE,
 	.getgeo		= sm_getgeo,


