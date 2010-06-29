Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0F2KPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab0F2KPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aTVL1hBmkEUqdy65wVWfC/AUjDpUFJLjQecA/X12NzAKhvIursaRRyEyxgd+uD2GCd
         ru0yUE2nIzl2OxOnG10ZVtJ/4qZo7fMs2nl6yYft6/NO1Rpq0aeze2n+sqeaQ/3gNCfh
         hFB2gGI90c4DGMzmtSdYn6oqVmx+i6UlyqM6A=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Benjamin Adolphi <b.adolphi@gmail.com>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/25] pcm3724: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:36 +0400
Message-Id: <1277806537-31078-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/comedi/drivers/pcm3724.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcm3724.c b/drivers/staging/comedi/drivers/pcm3724.c
index ed61030..0e91d95 100644
--- a/drivers/staging/comedi/drivers/pcm3724.c
+++ b/drivers/staging/comedi/drivers/pcm3724.c
@@ -184,7 +184,7 @@ static void enable_chan(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct priv_pcm3724 *priv;
 
 	gatecfg = 0;
-	priv = (struct priv_pcm3724 *)(dev->private);
+	priv = dev->private;
 
 	mask = 1 << CR_CHAN(chanspec);
 	if (s == dev->subdevices)	/*  subdev 0 */
-- 
1.7.0.4

