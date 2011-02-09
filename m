Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1BIKH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:07:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46668 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab1BIKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:07:54 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] trivial: fix typos concerning "function" and "through"
Date: Wed,  9 Feb 2011 11:07:38 +0100
Message-Id: <1297246062-23777-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 lib/average.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/average.c b/lib/average.c
index 5576c28..debcda4 100644
--- a/lib/average.c
+++ b/lib/average.c
@@ -17,8 +17,8 @@
  * Averages (EWMA). We keep a structure with the EWMA parameters and a scaled
  * up internal representation of the average value to prevent rounding errors.
  * The factor for scaling up and the exponential weight (or decay rate) have to
- * be specified thru the init fuction. The structure should not be accessed
- * directly but only thru the helper functions.
+ * be specified through the init function. The structure should not be accessed
+ * directly but only through the helper functions.
  */
 
 /**
-- 
1.7.2.3

