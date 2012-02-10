Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab2BJPCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:02:05 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42877 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759448Ab2BJPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:01:50 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Danny Kukawka <dkukawka@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mt2063: remove mt2063_setTune from header
Date: Fri, 10 Feb 2012 16:01:41 +0100
Message-Id: <1328886101-22701-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328886109;5852ff8e;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 99ac54125490f16f7434f82fcb73bbb88290b38e removed
the function mt2063_setTune() from mt2063.c. Remove it
also from the header file.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/media/common/tuners/mt2063.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index 62d0e8e..3f5cfd9 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -23,10 +23,6 @@ static inline struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 	return NULL;
 }
 
-int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
-				   u32 bw_in,
-				   enum MTTune_atv_standard tv_type);
-
 /* FIXME: Should use the standard DVB attachment interfaces */
 unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe);
 unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe);
-- 
1.7.7.3

