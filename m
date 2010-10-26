Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340Ab0JZT6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:58:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329Ab0JZT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:58 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: gregkh@suse.de
Cc: trivial@kernel.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging/trivial: fix typos concerning "configure"
Date: Tue, 26 Oct 2010 21:57:52 +0200
Message-Id: <1288123073-22470-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/staging/comedi/drivers/rtd520.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 60ebfc3..aa8aeee 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -753,7 +753,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev;
 	int ret;
-	resource_size_t physLas0;	/* configuation */
+	resource_size_t physLas0;	/* configuration */
 	resource_size_t physLas1;	/* data area */
 	resource_size_t physLcfg;	/* PLX9080 */
 #ifdef USE_DMA
-- 
1.7.2.3

