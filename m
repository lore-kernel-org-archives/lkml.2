Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab2EKKlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:41:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63800 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759362Ab2EKKlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:41:21 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 13/25] Staging: comedi: Checkpatch cleanups.
Date: Fri, 11 May 2012 16:08:01 +0530
Message-Id: <1336732693-7408-14-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/das6402.c:244: ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das6402.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
index f256841..893d850 100644
--- a/drivers/staging/comedi/drivers/das6402.c
+++ b/drivers/staging/comedi/drivers/das6402.c
@@ -241,7 +241,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
 
 #ifdef unused
 static int das6402_ai_mode2(struct comedi_device *dev,
-			    struct comedi_subdevice *s, comedi_trig * it)
+			    struct comedi_subdevice *s, comedi_trig *it)
 {
 	devpriv->das6402_ignoreirq = 1;
 	dev_dbg(dev->hw_dev, "Starting acquisition\n");
-- 
1.7.0.4

