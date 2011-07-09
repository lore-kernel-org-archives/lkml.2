Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1GIH7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 03:59:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61817 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab1GIH7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 03:59:05 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 10/10] Re:[PATCH]Staging: comedi: fix brace coding style issue in rtd520.c
Date: Sat,  9 Jul 2011 13:41:33 +0530
Message-Id: <1310199093-24890-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix braces issue in rtd520.c>
References: <[PATCH]Staging: comedi: fix braces issue in rtd520.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>

---

There is no braces in earlier now it's fixed.
---
 drivers/staging/comedi/drivers/rtd520.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 31a96c9..c41512a 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1410,11 +1410,12 @@ static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
 		}
 
 		d = d >> 3;	/* low 3 bits are marker lines */
-		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan))
+		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan)) {
 			/* convert to comedi unsigned data */
 			sample = d + 2048;
-		else
+		} else {
 			sample = d;
+		}
 
 		if (!comedi_buf_put(s->async, sample))
 			return -1;
-- 
1.6.5.2

