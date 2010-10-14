Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0JNJGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:06:32 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:57094 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab0JNJGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:06:31 -0400
Cc: linux-kernel@vger.kernel.org, ddbua@analog.com, drivers@analog.com,
        mike.frysinger@analog.com, chrisv@cyberswitching.com,
        Michael Hennerich <michael.hennerich@analog.com>
X-IronPort-AV: E=Sophos;i="4.57,329,1283745600"; 
   d="scan'208";a="23340935"
From: <michael.hennerich@analog.com>
To: akpm@linux-foundation.org
Subject: [PATCH 1/3] drivers: misc: ad525x_dpot: Fix typo in spi write16 and write24 transfer counts
Date: Thu, 14 Oct 2010 10:59:46 +0200
Message-ID: <1287046788-25122-1-git-send-email-michael.hennerich@analog.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>


Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
---
 drivers/misc/ad525x_dpot-spi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ad525x_dpot-spi.c b/drivers/misc/ad525x_dpot-spi.c
index b8c6df9..6cfcb63 100644
--- a/drivers/misc/ad525x_dpot-spi.c
+++ b/drivers/misc/ad525x_dpot-spi.c
@@ -53,13 +53,13 @@ static int write8(void *client, u8 val)
 static int write16(void *client, u8 reg, u8 val)
 {
 	u8 data[2] = {reg, val};
-	return spi_write(client, data, 1);
+	return spi_write(client, data, 2);
 }
 
 static int write24(void *client, u8 reg, u16 val)
 {
 	u8 data[3] = {reg, val >> 8, val};
-	return spi_write(client, data, 1);
+	return spi_write(client, data, 3);
 }
 
 static int read8(void *client)
-- 
1.6.0.2

