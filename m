Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab0IIWee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:34:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58564 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab0IIW3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Rnf9F1+WE8ZvmdRX51aaj4+Ad+JFn+fysYXb1YHYJ9toxXni1iMCEKnp1O4U95fucr
         X5QGEQuJQlmTodMtd+ckBMjQy7fcc3DqBSd4k+0Lk9Ur5mD9SbuDZxOmQ0gEcGelYNFZ
         bRVkyhgnaY8V+oAMQQ8vbM8WwK3zYJ8aQN78A=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 077/223]drivers/mtd/maps/dilnetpc.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:29:21 -0700
Message-Id: <1284071374-7867-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
References: <1284071374-7867-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/mtd/maps/dilnetpc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/dilnetpc.c b/drivers/mtd/maps/dilnetpc.c
index 0713e3a..63d0997 100644
--- a/drivers/mtd/maps/dilnetpc.c
+++ b/drivers/mtd/maps/dilnetpc.c
@@ -19,8 +19,7 @@
  * board: DNP/1486 and ADNP/1486. The DNP version has 2 megs of flash
  * ROM (Intel 28F016S3) and 8 megs of DRAM, the ADNP version has 4 megs
  * flash and 16 megs of RAM.
- * For details, see http://www.ssv-embedded.de/ssv/pc104/p169.htm
- * and http://www.ssv-embedded.de/ssv/pc104/p170.htm
+ * For details, see http://www.ssv-comm.de/en/products/index.php 
  */
 
 #include <linux/module.h>
-- 
1.7.2.1

