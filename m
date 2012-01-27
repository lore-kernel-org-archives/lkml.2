Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2A0PKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:10:11 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:53568
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755808Ab2A0PKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:10:08 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] media: Fix typo in ov6650.c
Date: Sat, 28 Jan 2012 00:04:51 +0900
Message-Id: <1327676691-2566-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "unspported" to "unsupported" in
drivers/media/video/ov6650.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/video/ov6650.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index 6806345..3627f32 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -649,7 +649,7 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 			clkrc = CLKRC_24MHz;
 		} else {
 			dev_err(&client->dev,
-				"unspported input clock, check platform data\n");
+				"unsupported input clock, check platform data\n");
 			return -EINVAL;
 		}
 		mclk = sense->master_clock;
-- 
1.7.6.5

