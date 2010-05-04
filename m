Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0EDE0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 00:26:45 -0400
Received: from [69.28.251.93] ([69.28.251.93]:47962 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab0EDE0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 00:26:43 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 3 May 2010 21:20:04 -0700
Subject: [PATCH] mtd: Increase NAND_MAX_OOBSIZE from 128 to 256
Message-Id: <e511d9573281d8376f800574fac2d72663e2d558@localhost.localdomain>
To: <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAND_MAX_OOBSIZE needs to be increased to support newer parts with
218 or 224 byte spare areas.  Tested with Samsung K9GAG08U0D.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 include/linux/mtd/nand.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 8bdacb8..50f3aa0 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -53,7 +53,7 @@ extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
  * is supported now. If you add a chip with bigger oobsize/page
  * adjust this accordingly.
  */
-#define NAND_MAX_OOBSIZE	128
+#define NAND_MAX_OOBSIZE	256
 #define NAND_MAX_PAGESIZE	4096
 
 /*
-- 
1.6.3.1

