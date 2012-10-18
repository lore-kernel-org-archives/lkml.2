Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2JRT2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:28:17 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:18650 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2JRT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:28:16 -0400
Date: Thu, 18 Oct 2012 21:28:10 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] s5p-tv: don't include linux/version.h in
 mixer_video.c
Message-ID: <alpine.LNX.2.00.1210182125380.17217@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header is not needed, so remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/platform/s5p-tv/mixer_video.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 0c1cd89..9b52f3a 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -19,7 +19,6 @@
 #include <linux/videodev2.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/timer.h>
 #include <media/videobuf2-dma-contig.h>
 
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

