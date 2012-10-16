Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2JPQiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:38:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56957 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2JPQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:38:16 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 4/4] staging: csr: Fixed foo ++; to foo++; on mlme.c
Date: Wed, 17 Oct 2012 01:36:48 +0900
Message-Id: <1350405408-2702-4-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350405408-2702-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350405408-2702-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing code as foo ++; is a coding style ERROR, so I modifed the code
to foo++;.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/csr/mlme.c b/drivers/staging/csr/mlme.c
index e4ecdd8..25b2d1d 100644
--- a/drivers/staging/csr/mlme.c
+++ b/drivers/staging/csr/mlme.c
@@ -118,7 +118,7 @@ unifi_mlme_wait_for_reply(unifi_priv_t *priv, ul_client_t *pcli,
 			/* Wait for the next signal. */
 			pcli->wake_up_wq_id = 0;
 
-			retries ++;
+			retries++;
 			if (retries >= 3) {
 				unifi_error(priv, "mlme_wait: confirm wait retries exhausted (0x%.4X - exp 0x%.4X)\n",
 					pcli->wake_up_wq_id, sig_reply_id);
-- 
1.7.9.5

