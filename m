Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0GMJ2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:28:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46647 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0GMJ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:28:07 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix typos concerning "challenge"
Date: Tue, 13 Jul 2010 11:27:58 +0200
Message-Id: <1279013278-21558-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
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
 drivers/net/wireless/hostap/hostap_ap.c |    2 +-
 sound/soc/imx/imx-ssi.c                 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 231dbd7..cb3c25f 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -1225,7 +1225,7 @@ static void ap_crypt_init(struct ap_data *ap)
 
 
 /* Generate challenge data for shared key authentication. IEEE 802.11 specifies
- * that WEP algorithm is used for generating challange. This should be unique,
+ * that WEP algorithm is used for generating challenge. This should be unique,
  * but otherwise there is not really need for randomness etc. Initialize WEP
  * with pseudo random key and then use increasing IV to get unique challenge
  * streams.
diff --git a/sound/soc/imx/imx-ssi.c b/sound/soc/imx/imx-ssi.c
index 80b4fee..4fd13d0 100644
--- a/sound/soc/imx/imx-ssi.c
+++ b/sound/soc/imx/imx-ssi.c
@@ -23,7 +23,7 @@
  * between pcm data and GPIO status data changes. Our FIQ handler is not
  * able to handle this, hence this driver only works with 48000Hz sampling
  * rate.
- * Reading and writing AC97 registers is another challange. The core
+ * Reading and writing AC97 registers is another challenge. The core
  * provides us status bits when the read register is updated with *another*
  * value. When we read the same register two times (and the register still
  * contains the same value) these status bits are not set. We work
-- 
1.7.1

