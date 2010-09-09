Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab0IIW3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:29:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58564 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab0IIW3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=EidPLu2U8nXVSKgabj2FiJEbxEB4dbhtd65lK376E7kxkdQ98YhSmm/67Bm7N7FGRg
         iEo0yFg3I255yxNsUtFv0fq1ICwg7Rh06PIxXHRMtS083M4eQAT2wDzWXm2PvuV0b494
         Ktc1rY0rvS4XcG0RqV5o/Y29HIUreonkW2Kjc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=20076/223=5Ddrivers/mtd/nand/cafe=5Fnand=2Ec=20Update=20broken=20web=20addresses=2E?=
Date: Thu,  9 Sep 2010 15:29:20 -0700
Message-Id: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/mtd/nand/cafe_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index db1dfc5..9fc8145 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -2,7 +2,7 @@
  * Driver for One Laptop Per Child ‘CAFÉ’ controller, aka Marvell 88ALP01
  *
  * The data sheet for this device can be found at:
- *    http://www.marvell.com/products/pcconn/88ALP01.jsp
+ *   http://www.marvell.com/products/pc_connectivity/88alp01/ 
  *
  * Copyright © 2006 Red Hat, Inc.
  * Copyright © 2006 David Woodhouse <dwmw2@infradead.org>
-- 
1.7.2.1

