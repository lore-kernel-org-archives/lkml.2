Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0JVFR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:17:28 -0400
Received: from mail.perches.com ([173.55.12.10]:3459 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab0JVFRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:17:25 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] drivers/ata: typo fix of faild to failed
Date: Thu, 21 Oct 2010 22:17:12 -0700
Message-Id: <bedb981e6fff0e087135a9d7ef78e793dd73ee5e.1287724261.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/pata_bf54x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index ec2c777..7aed5c7 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1588,7 +1588,7 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 	host->ports[0]->ioaddr.ctl_addr = (void *)res->start;
 
 	if (peripheral_request_list(atapi_io_port, "atapi-io-port")) {
-		dev_err(&pdev->dev, "Requesting Peripherals faild\n");
+		dev_err(&pdev->dev, "Requesting Peripherals failed\n");
 		return -EFAULT;
 	}
 
-- 
1.7.3.1.g432b3.dirty

