Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1BYGNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:13:10 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34701 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1BYGNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rcDoTnI/WPj8MotuUf2DAjIr86kmzA3OJYxDYapRCFqB10TIklBTQhahGTgq5dP2be
         LvRSk6i44rc8AiyRetaRY7yLjRFPkRxpv65fAeC/e9VtV7BTq4ZKCi1kSPb9RDGX5dgi
         wSI5jiBd4jyzEJBJ/uSJZwhPgk4eLS7p28kLE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 10/21]drivers:spi:spi_topcliff_pch.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:12:50 -0800
Message-Id: <1298614370-3841-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/spi/spi_topcliff_pch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
index 79e48d4..75f8f13 100644
--- a/drivers/spi/spi_topcliff_pch.c
+++ b/drivers/spi/spi_topcliff_pch.c
@@ -1022,7 +1022,7 @@ static int pch_spi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	board_dat->pdev = pdev;
 
-	/* alllocate memory for SPI master */
+	/* allocate memory for SPI master */
 	master = spi_alloc_master(&pdev->dev, sizeof(struct pch_spi_data));
 	if (master == NULL) {
 		retval = -ENOMEM;
-- 
1.7.4.1

