Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213Ab2GDIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:09:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36202 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab2GDIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:08:50 -0400
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 4/5] ubi: trivial: fix comment of ubi_calculate_reserved()
Date: Wed,  4 Jul 2012 11:06:03 +0300
Message-Id: <1341389164-24409-5-git-send-email-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function name within the comment was not aligned with the actual
function name.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
 drivers/mtd/ubi/misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/misc.c b/drivers/mtd/ubi/misc.c
index e9dcb83..25b564f 100644
--- a/drivers/mtd/ubi/misc.c
+++ b/drivers/mtd/ubi/misc.c
@@ -92,7 +92,7 @@ int ubi_check_volume(struct ubi_device *ubi, int vol_id)
 }
 
 /**
- * ubi_calculate_rsvd_pool - calculate how many PEBs must be reserved for bad
+ * ubi_calculate_reserved - calculate how many PEBs must be reserved for bad
  * eraseblock handling.
  * @ubi: UBI device description object
  */
-- 
1.7.9

