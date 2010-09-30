Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0I3Szd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:55:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47883 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab0I3Szc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=QwL0E1FUuGm6hsUipoWdAv+zSFgvN1j+ti/hAjNEWZFwUOK7ZqKgTJifvO/ZtW7GFp
         5h+3L8jAFAA3UEusCUeE0Zx6Tobw4lzn5fwCqBCioG2fLkQyx0mb4tGjryp8dy6x9jEp
         ivwCj4frD7WqSS2WO0R9hONLeNyjV68IyQ8W8=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com, tsanghan@gmail.com,
        u.kleine-koenig@pengutronix.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] staging: comedi: file: Removed whitespaces before quoted newlines
Date: Thu, 30 Sep 2010 19:55:18 +0100
Message-Id: <1285872918-2990-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unnecessary whitespaces before quoted newlines

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index b0e39cb..7600431 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -1235,7 +1235,7 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 							 * align to 32bit down
 							 */
 	}
-	DPRINTK("2 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("2 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 
 	/* we want wake up every scan? */
 	if (devpriv->ai_flags & TRIG_WAKE_EOS) {
@@ -1295,7 +1295,7 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 		}
 	}
 
-	DPRINTK("3 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("3 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 	/* transfer without TRIG_WAKE_EOS */
 	if (!(devpriv->ai_flags & TRIG_WAKE_EOS)) {
 		/* if it's possible then allign DMA buffers to length of scan */
@@ -1323,13 +1323,13 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 			    ((devpriv->ai_n_realscanlen << 1) *
 			     devpriv->ai_scans)) {
 				DPRINTK
-				    ("3.0 ai_n_realscanlen=%d ai_scans=%d \n",
+				    ("3.0 ai_n_realscanlen=%d ai_scans=%d\n",
 				     devpriv->ai_n_realscanlen,
 				     devpriv->ai_scans);
 				dmalen0 =
 				    (devpriv->ai_n_realscanlen << 1) *
 				    devpriv->ai_scans;
-				DPRINTK("3.1 dmalen0=%d dmalen1=%d \n", dmalen0,
+				DPRINTK("3.1 dmalen0=%d dmalen1=%d\n", dmalen0,
 					dmalen1);
 				dmalen0 &= ~3L;
 			} else {	/*
@@ -1342,21 +1342,21 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 					dmalen1 =
 					    (devpriv->ai_n_realscanlen << 1) *
 					    devpriv->ai_scans - dmalen0;
-				DPRINTK("3.2 dmalen0=%d dmalen1=%d \n", dmalen0,
+				DPRINTK("3.2 dmalen0=%d dmalen1=%d\n", dmalen0,
 					dmalen1);
 				dmalen1 &= ~3L;
 			}
 		}
 	}
 
-	DPRINTK("4 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("4 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 
 	/* these DMA buffer size will be used */
 	devpriv->dma_actbuf = 0;
 	devpriv->dmabuf_use_size[0] = dmalen0;
 	devpriv->dmabuf_use_size[1] = dmalen1;
 
-	DPRINTK("5 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("5 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 #if 0
 	if (devpriv->ai_n_scanlen < this_board->half_fifo_size) {
 		devpriv->dmabuf_panic_size[0] =
-- 
1.7.0.4

