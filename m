Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab2EKKoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:44:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab2EKKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:41:15 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 12/25] Staging: comedi: Checkpatch cleanups.
Date: Fri, 11 May 2012 16:08:00 +0530
Message-Id: <1336732693-7408-13-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/s626.c:1422: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/comedi/drivers/s626.c:1422: ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/s626.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index aef9a3d..b7f36e4 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -321,7 +321,7 @@ static unsigned int s626_ai_reg_to_uint(int data);
 
 /* internal routines */
 static void s626_dio_init(struct comedi_device *dev);
-static void ResetADC(struct comedi_device *dev, uint8_t * ppl);
+static void ResetADC(struct comedi_device *dev, uint8_t *ppl);
 static void LoadTrimDACs(struct comedi_device *dev);
 static void WriteTrimDAC(struct comedi_device *dev, uint8_t LogicalChan,
 			 uint8_t DacData);
@@ -1419,7 +1419,7 @@ static int s626_detach(struct comedi_device *dev)
 /*
  * this functions build the RPS program for hardware driven acquistion
  */
-void ResetADC(struct comedi_device *dev, uint8_t * ppl)
+void ResetADC(struct comedi_device *dev, uint8_t *ppl)
 {
 	register uint32_t *pRPS;
 	uint32_t JmpAdrs;
-- 
1.7.0.4

