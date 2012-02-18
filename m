Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2BRR2D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 12:28:03 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:48189
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2BRR2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 12:28:01 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] davinci: Fix typo in dm355_ccdvc.c
Date: Sun, 19 Feb 2012 02:27:32 +0900
Message-Id: <1329586052-3415-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "thresold" to "threshold" in
drivers/media/video/davinci/dm355_ccdc.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/video/davinci/dm355_ccdc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index f83baf3..5b68847 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -292,7 +292,7 @@ static int validate_ccdc_param(struct ccdc_config_params_raw *ccdcparam)
 	if ((ccdcparam->med_filt_thres < 0) ||
 	   (ccdcparam->med_filt_thres > CCDC_MED_FILT_THRESH)) {
 		dev_dbg(ccdc_cfg.dev,
-			"Invalid value of median filter thresold\n");
+			"Invalid value of median filter threshold\n");
 		return -EINVAL;
 	}
 
-- 
1.7.6.5

