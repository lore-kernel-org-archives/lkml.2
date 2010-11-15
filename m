Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0KODFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:47 -0500
Received: from mail.perches.com ([173.55.12.10]:1208 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab0KODFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:46 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wan ZongShun <mcuos.com@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 28/44] drivers/spi: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:47 -0800
Message-Id: <fe5e5e0efbd97eaa32530eef5ed47efdc3252dad.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/spi/amba-pl022.c |    2 +-
 drivers/spi/spi_nuc900.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index fb3d1b3..2e50631 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -956,7 +956,7 @@ static int configure_dma(struct pl022 *pl022)
 		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
 		break;
 	case WRITING_U32:
-		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;;
+		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 		break;
 	}
 
diff --git a/drivers/spi/spi_nuc900.c b/drivers/spi/spi_nuc900.c
index dff63be..d5be18b 100644
--- a/drivers/spi/spi_nuc900.c
+++ b/drivers/spi/spi_nuc900.c
@@ -449,7 +449,7 @@ err_iomap:
 	release_mem_region(hw->res->start, resource_size(hw->res));
 	kfree(hw->ioarea);
 err_pdata:
-	spi_master_put(hw->master);;
+	spi_master_put(hw->master);
 
 err_nomem:
 	return err;
-- 
1.7.3.1.g432b3.dirty

