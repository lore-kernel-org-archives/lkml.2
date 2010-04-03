Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0DCQ3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 12:29:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54019 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0DCQ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 12:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=F2WShbbb9oL10XNWvrZkcvT0AeaVEvlsi0u5UIGzL1/VhdUcDFX/2TLEilAvrNbRNE
         m3959KFwOlvKNyFx6C0Ug9/w817DtJjwWznOYQ8l31BThkP6lrCFEJYyzj2ADGaChnJJ
         GQATjtCUawghv5qrrLjaOFTCS7v1bNGCROT/8=
From: Wan Wei <onewayforever@gmail.com>
To: mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, Wan Wei <onewayforever@gmail.com>
Subject: [PATCH] fix bug in register mci on drivers/edac/i7core_edac.c
Date: Sun,  4 Apr 2010 00:29:38 +0800
Message-Id: <1270312178-9343-1-git-send-email-onewayforever@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wan Wei<onewayforever@gmail.com>

---
 drivers/edac/i7core_edac.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index aa40dbe..583c1d1 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1804,6 +1804,8 @@ static int i7core_register_mci(struct i7core_dev *i7core_dev,
 			": %s(): failed edac_mce_register()\n", __func__);
 	}
 
+	return 0;
+
 fail:
 	edac_mc_free(mci);
 	return rc;
-- 
1.6.0.4

