Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab0FKKRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:17:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37040 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760187Ab0FKKRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:30 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] trivial: fix typos concerning "associate"
Date: Fri, 11 Jun 2010 12:16:58 +0200
Message-Id: <1276251424-12806-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100611101624.GD10894@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de>
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
 drivers/rapidio/rio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 08fa453..74e9d22 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -808,7 +808,7 @@ int rio_std_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount,
 
 /**
  * rio_std_route_get_entry - Read switch route table entry (port number)
- *   assosiated with specified destID using standard registers defined in RIO
+ *   associated with specified destID using standard registers defined in RIO
  *   specification rev.1.3
  * @mport: Master port to issue transaction
  * @destid: Destination ID of the device
-- 
1.7.1

