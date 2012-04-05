Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2DEGDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:03:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54343 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2DEGDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:03:02 -0400
From: santosh nayak <santoshprasadnayak@gmail.com>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH 1/2] Agp: Remove 'break' after 'return' statement.
Date: Thu,  5 Apr 2012 11:31:08 +0530
Message-Id: <1333605668-18622-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

'break' is unnecessary after 'return' statement.
Remove all such 'break' as clean up.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/char/agp/generic.c |    2 --
 drivers/char/agp/sgi-agp.c |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 17e05d1..38022ea 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1010,7 +1010,6 @@ int agp_generic_free_gatt_table(struct agp_bridge_data *bridge)
 	case LVL2_APER_SIZE:
 		/* The generic routines can't deal with 2 level gatt's */
 		return -EINVAL;
-		break;
 	default:
 		page_order = 0;
 		break;
@@ -1077,7 +1076,6 @@ int agp_generic_insert_memory(struct agp_memory * mem, off_t pg_start, int type)
 	case LVL2_APER_SIZE:
 		/* The generic routines can't deal with 2 level gatt's */
 		return -EINVAL;
-		break;
 	default:
 		num_entries = 0;
 		break;
diff --git a/drivers/char/agp/sgi-agp.c b/drivers/char/agp/sgi-agp.c
index ffa888c..1920003 100644
--- a/drivers/char/agp/sgi-agp.c
+++ b/drivers/char/agp/sgi-agp.c
@@ -158,7 +158,6 @@ static int sgi_tioca_insert_memory(struct agp_memory *mem, off_t pg_start,
 		break;
 	case LVL2_APER_SIZE:
 		return -EINVAL;
-		break;
 	default:
 		num_entries = 0;
 		break;
-- 
1.7.4.4

