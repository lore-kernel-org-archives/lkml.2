Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab1KRKJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:09:15 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:59252
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501Ab1KRKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:09:11 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
From: <michael.hennerich@analog.com>
To: <greg@kroah.com>, <arnd@arndb.de>
CC: <device-drivers-devel@blackfin.uclinux.org>, <drivers@analog.com>,
        <linux-kernel@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 1/2] misc: ad525x_dpot: Fix AD8400 spi transfer size.
Date: Fri, 18 Nov 2011 11:05:10 +0100
Message-ID: <1321610711-12507-1-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

AD8400 type devices require 16-bit command transfers.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
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
1.7.0.4


