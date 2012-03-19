Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161291Ab2CSPSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:18:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56306 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656Ab2CSPSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:18:05 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, "Justin P. Mattock" <justinmattock@gmail.com>,
        Chris Kelly <ckelly@ozmodevices.com>
Subject: [PATCH 2/5]NEXT:drivers:staging:ozwpan:ozhcd.c Fix typos in staging:ozwpan
Date: Mon, 19 Mar 2012 08:17:50 -0700
Message-Id: <1332170273-3482-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
References: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo that I found while reading.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Chris Kelly <ckelly@ozmodevices.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 750b14e..cfa25e8 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1463,7 +1463,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 			rc = -ENOMEM;
 		} else {
 			/* Note: we are queuing the request after we have
-			 * submitted it to be tranmitted. If the request were
+			 * submitted it to be transmitted. If the request were
 			 * to complete before we queued it then it would not
 			 * be found in the queue. It seems impossible for
 			 * this to happen but if it did the request would
-- 
1.7.5.4

