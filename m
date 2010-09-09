Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab0IIWeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:34:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58564 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab0IIW3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:29:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RbeaELN/EfMSAFhlyGdKLUv6+XinviPa95SoEzD7mfn5C/ccvzjPIbieclRQ3pFroz
         e1MjWnaFt/MNuP9nlMDGGMHgcz2Gcwn7sJK+ywQFikwZJHH8lXudsGhzauZiCOVG2f3j
         f/nu19ZO0SVH9825z/bjJJ7Av/bRa9Hr5K30s=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 078/223]drivers/mtd/maps/sc520cdp.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:29:22 -0700
Message-Id: <1284071374-7867-3-git-send-email-justinmattock@gmail.com>
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
 drivers/mtd/maps/sc520cdp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/sc520cdp.c b/drivers/mtd/maps/sc520cdp.c
index 85c1e56..c3eb3c0 100644
--- a/drivers/mtd/maps/sc520cdp.c
+++ b/drivers/mtd/maps/sc520cdp.c
@@ -20,7 +20,7 @@
  * The SC520CDP is an evaluation board for the Elan SC520 processor available
  * from AMD. It has two banks of 32-bit Flash ROM, each 8 Megabytes in size,
  * and up to 512 KiB of 8-bit DIL Flash ROM.
- * For details see http://www.amd.com/products/epd/desiging/evalboards/18.elansc520/520_cdp_brief/index.html
+ * For details see http://web.archive.org/web/*/http://www.amd.com/products/epd/desiging/evalboards/18.elansc520/520_cdp_brief/index.html 
  */
 
 #include <linux/module.h>
-- 
1.7.2.1

