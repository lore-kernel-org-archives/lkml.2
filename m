Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab1KVBLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:11:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757040Ab1KVBLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:11:21 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/7] misc: ad525x_dpot: Fix AD8400 spi transfer size.
Date: Mon, 21 Nov 2011 17:10:34 -0800
Message-Id: <1321924234-26258-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321924234-26258-1-git-send-email-gregkh@suse.de>
References: <20111122005836.GA25420@kroah.com>
 <1321924234-26258-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

AD8400 type devices require 16-bit command transfers.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ad525x_dpot.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.h b/drivers/misc/ad525x_dpot.h
index a662f59..82b2cb7 100644
--- a/drivers/misc/ad525x_dpot.h
+++ b/drivers/misc/ad525x_dpot.h
@@ -100,7 +100,7 @@ enum dpot_devid {
 	AD5293_ID = DPOT_CONF(F_RDACS_RW | F_SPI_16BIT, BRDAC0, 10, 27),
 	AD7376_ID = DPOT_CONF(F_RDACS_WONLY | F_AD_APPDATA | F_SPI_8BIT,
 			BRDAC0, 7, 28),
-	AD8400_ID = DPOT_CONF(F_RDACS_WONLY | F_AD_APPDATA | F_SPI_8BIT,
+	AD8400_ID = DPOT_CONF(F_RDACS_WONLY | F_AD_APPDATA | F_SPI_16BIT,
 			BRDAC0, 8, 29),
 	AD8402_ID = DPOT_CONF(F_RDACS_WONLY | F_AD_APPDATA | F_SPI_16BIT,
 			BRDAC0 | BRDAC1, 8, 30),
-- 
1.7.7.3

