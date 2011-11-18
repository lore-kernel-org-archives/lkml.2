Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1KREjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:39:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33608 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab1KREjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:39:04 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 4/4] Drivers: video: sbuslib: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 21:38:58 -0700
Message-Id: <1321591138-8334-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/video/sbuslib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sbuslib.c b/drivers/video/sbuslib.c
index 37d764a..3c1de98 100644
--- a/drivers/video/sbuslib.c
+++ b/drivers/video/sbuslib.c
@@ -76,7 +76,7 @@ int sbusfb_mmap_helper(struct sbus_mmap_map *map,
 				map_offset = (physbase + map[i].poff) & POFF_MASK;
 				break;
 			}
-		if (!map_size){
+		if (!map_size) {
 			page += PAGE_SIZE;
 			continue;
 		}
-- 
1.7.7.3

