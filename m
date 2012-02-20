Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2BTOcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:32:18 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:52571
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2BTOcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:32:15 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] [trivial] staging: Fix typo in unioxx5.c
Date: Mon, 20 Feb 2012 23:31:30 +0900
Message-Id: <1329748291-1768-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329748291-1768-1-git-send-email-standby24x7@gmail.com>
References: <1329748291-1768-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "erorr" to "error" in
drivers/stating/comedi/drivers/unioxx5.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 89e62aa..f45824f 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -306,7 +306,7 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 	usp = kzalloc(sizeof(*usp), GFP_KERNEL);
 
 	if (usp == NULL) {
-		printk(KERN_ERR "comedi%d: erorr! --> out of memory!\n", minor);
+		printk(KERN_ERR "comedi%d: error! --> out of memory!\n", minor);
 		return -1;
 	}
 
-- 
1.7.6.5

