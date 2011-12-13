Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1LMFQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 00:16:54 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50922 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1LMFQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 00:16:53 -0500
MIME-Version: 1.0
Date: Tue, 13 Dec 2011 10:46:53 +0530
Message-ID: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com>
Subject: [PATCH 1/1] Staging: zram: print the disk size in KB
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a5d5ba92b5af9134e617986884856334c377e1d0 Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Mon, 12 Dec 2011 18:42:30 +0530
Subject: [PATCH 1/1] Staging: zram: print the disk size in KB

Total memory size is in KB, but the zram disk size was not
printed in KB, correct the figure in KB units.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 drivers/staging/zram/zram_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 09de99f..ff591e3 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -126,7 +126,7 @@ static void zram_set_disksize(struct zram *zram,
size_t totalram_bytes)
 		"\tMemory Size: %zu kB\n"
 		"\tSize you selected: %llu kB\n"
 		"Continuing anyway ...\n",
-		totalram_bytes >> 10, zram->disksize
+		totalram_bytes >> 10, zram->disksize >> 10
 		);
 	}

--
