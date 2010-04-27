Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0D0Qco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:32:44 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:42081 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab0D0Qcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:32:43 -0400
X-Greylist: delayed 953 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 12:32:42 EDT
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH] bttv: Add another ids for IVC-200
Date: Tue, 27 Apr 2010 20:17:51 +0400
Message-Id: <1272385071-26310-1-git-send-email-kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.1.rc2.12.g3a006
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have 3 IVC-200 cards (with 4 video channels on each).

2 of the cards identify theirselves as 000[0-3]:a155 (ids already in
cardlist) and another one identifies itself as 080[0-3]:a155, which ids
were unknown so far.

Note - it's IVC-200, not IVC-200G.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 Documentation/video4linux/CARDLIST.bttv |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c  |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.bttv b/Documentation/video4linux/CARDLIST.bttv
index f11c583..4739d56 100644
--- a/Documentation/video4linux/CARDLIST.bttv
+++ b/Documentation/video4linux/CARDLIST.bttv
@@ -100,7 +100,7 @@
  99 -> AD-TVK503
 100 -> Hercules Smart TV Stereo
 101 -> Pace TV & Radio Card
-102 -> IVC-200                                             [0000:a155,0001:a155,0002:a155,0003:a155,0100:a155,0101:a155,0102:a155,0103:a155]
+102 -> IVC-200                                             [0000:a155,0001:a155,0002:a155,0003:a155,0100:a155,0101:a155,0102:a155,0103:a155,0800:a155,0801:a155,0802:a155,0803:a155]
 103 -> Grand X-Guard / Trust 814PCI                        [0304:0102]
 104 -> Nebula Electronics DigiTV                           [0071:0101]
 105 -> ProVideo PV143                                      [aa00:1430,aa00:1431,aa00:1432,aa00:1433,aa03:1433]
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 716870a..7af56cd 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -241,6 +241,10 @@ static struct CARD {
 	{ 0xa1550101, BTTV_BOARD_IVC200,        "IVC-200G" },
 	{ 0xa1550102, BTTV_BOARD_IVC200,        "IVC-200G" },
 	{ 0xa1550103, BTTV_BOARD_IVC200,        "IVC-200G" },
+	{ 0xa1550800, BTTV_BOARD_IVC200,        "IVC-200"  },
+	{ 0xa1550801, BTTV_BOARD_IVC200,        "IVC-200"  },
+	{ 0xa1550802, BTTV_BOARD_IVC200,        "IVC-200"  },
+	{ 0xa1550803, BTTV_BOARD_IVC200,        "IVC-200"  },
 	{ 0xa182ff00, BTTV_BOARD_IVC120,        "IVC-120G" },
 	{ 0xa182ff01, BTTV_BOARD_IVC120,        "IVC-120G" },
 	{ 0xa182ff02, BTTV_BOARD_IVC120,        "IVC-120G" },
-- 
1.7.1.rc2.12.g3a006

