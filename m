Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab0KOUQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:16:47 -0500
Received: from mail.perches.com ([173.55.12.10]:1337 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933649Ab0KOUOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:08 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] drivers/media/dvb/ngene/ngene-core.c: Remove unnecessary casts of pci_get_drvdata
Date: Mon, 15 Nov 2010 12:13:54 -0800
Message-Id: <374f6c46109836f43924f89b404ce423d63fed6c.1289851770.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289851770.git.joe@perches.com>
References: <cover.1289851770.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/ngene/ngene-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index 4caeb16..1999e35 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -1516,7 +1516,7 @@ static int init_channels(struct ngene *dev)
 
 void __devexit ngene_remove(struct pci_dev *pdev)
 {
-	struct ngene *dev = (struct ngene *)pci_get_drvdata(pdev);
+	struct ngene *dev = pci_get_drvdata(pdev);
 	int i;
 
 	tasklet_kill(&dev->event_tasklet);
-- 
1.7.3.1.g432b3.dirty

