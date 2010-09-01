Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0IANsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:48:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34100 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab0IANsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:48:47 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] trivial: fix typos concerning "relative"
Date: Wed,  1 Sep 2010 15:48:36 +0200
Message-Id: <1283348918-7204-13-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283348918-7204-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1283348918-7204-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 include/linux/mfd/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 11d740b..8bd48de 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -39,7 +39,7 @@ struct mfd_cell {
 	size_t			data_size;
 
 	/*
-	 * This resources can be specified relatievly to the parent device.
+	 * This resources can be specified relatively to the parent device.
 	 * For accessing device you should use resources from device
 	 */
 	int			num_resources;
-- 
1.7.1

