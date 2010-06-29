Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0F2KP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:15:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0F2KPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Oaz1miRQsX6Um5s5g2D1PtstDGXFvxkrRRiUSpdO27uKT/E2EfjoZqHYE/o3kpiijh
         mT85ywM4Q8gLp9raD0idXDhmNXpZ+gzWl8vCUGmKCDpPDPI9IwL9O/D6cHQGNjlblLXR
         GgHVwELth4ujKgzyFyiWJGAttVj44zKv1cJjo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Olimpiu Pascariu <olimpiu.pascariu@gmail.com>,
       Tejun Heo <tj@kernel.org>,
       Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
       sai gopal <tsg321@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 14/25] cx25821-alsa: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:47 +0400
Message-Id: <1277806548-31180-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/cx25821/cx25821-alsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index 1798975..ce2c6f1 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -699,7 +699,7 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 
 	/* Card "creation" */
 	card->private_free = snd_cx25821_dev_free;
-	chip = (struct cx25821_audio_dev *) card->private_data;
+	chip = card->private_data;
 	spin_lock_init(&chip->reg_lock);
 
 	chip->dev = dev;
-- 
1.7.0.4

