Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab1GJTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 15:16:56 -0400
Received: from nm5.bullet.mail.ukl.yahoo.com ([217.146.182.226]:48596 "HELO
	nm5.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756321Ab1GJTQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 15:16:55 -0400
X-Yahoo-Newman-Id: 161252.71745.bm@smtp144.mail.ukl.yahoo.com
X-Yahoo-SMTP: jJZJ2V.swBDUsw.4BFRh6Rcl_N0lOoI1XeCD
X-YMail-OSG: Dl3JXKcVM1mBlnZHpmebEzCQ9qil9M3UU5kcwDy9dPyS6r.
 2RRWr8FJy83OcGUrn9c700VhmV5uZkjcShitcdWk5V8hvl94WbNjDZun8OTq
 mGGni6xn1JctiXjoLhL8e4k_FSMahGoOixNIzntSR1P77GDOhJj41TfxF6jZ
 53XZ_YrQOWwvT2YW4ge8uLcezk10gAR2sbV8QCgazjfA_2TMZrlhoADgwc75
 jsfhbGPyylwyRhJjqtQR0QZE.b3wIGTJ63rwflPhdSJqpVN4hJ6FIx7ZkFGP
 92Z97VMtRm.aAA9KPRT_DVPUx1vS_J5SvKefcQTSK9ZLJmeEGXcdtcg--
X-Yahoo-Newman-Property: ymail-3
From: markpearson_de@yahoo.de
To: greg@kroah.com
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: [PATCH 1/2] Staging: comedi: Coding style issues
Date: Sun, 10 Jul 2011 21:16:37 +0200
Message-Id: <1310325398-30449-1-git-send-email-markpearson_de@yahoo.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Pearson <markpearson_de@yahoo.de>

comedi.h : static inline decleration placed on the same line as the end
           bracket from the previous static inline decleration.
           Bracket coding issue also cleaned-up.

Signed-off-by: Mark Pearson <markpearson_de@yahoo.de>
---
 drivers/staging/comedi/comedi.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 6c900e2..ed6854c 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -514,7 +514,9 @@
 			return 0x1 + pfi_channel;
 		else
 			return 0xb + pfi_channel;
-	} static inline unsigned NI_USUAL_RTSI_SELECT(unsigned rtsi_channel) {
+	}
+	static inline unsigned NI_USUAL_RTSI_SELECT(unsigned rtsi_channel)
+	{
 		if (rtsi_channel < 7)
 			return 0xb + rtsi_channel;
 		else
-- 
1.7.0.4

