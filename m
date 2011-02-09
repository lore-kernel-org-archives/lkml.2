Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1BIKIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:08:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46691 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1BIKI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:08:26 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] trivial: fix typos concerning "address"
Date: Wed,  9 Feb 2011 11:07:34 +0100
Message-Id: <1297246062-23777-2-git-send-email-u.kleine-koenig@pengutronix.de>
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
 arch/blackfin/mach-bf518/include/mach/defBF512.h |    2 +-
 arch/blackfin/mach-bf527/include/mach/defBF522.h |    2 +-
 arch/blackfin/mach-bf538/include/mach/defBF538.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mach-bf518/include/mach/defBF512.h b/arch/blackfin/mach-bf518/include/mach/defBF512.h
index 2728582..b1e60a9 100644
--- a/arch/blackfin/mach-bf518/include/mach/defBF512.h
+++ b/arch/blackfin/mach-bf518/include/mach/defBF512.h
@@ -1098,7 +1098,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length							*/
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid					*/
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call Adrress Matching Enabled		*/
+#define	GEN			0x0010		/* General Call Address Matching Enabled		*/
 
 /* TWI_SLAVE_STAT Masks															*/
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*)	*/
diff --git a/arch/blackfin/mach-bf527/include/mach/defBF522.h b/arch/blackfin/mach-bf527/include/mach/defBF522.h
index 89f5420..565cc69 100644
--- a/arch/blackfin/mach-bf527/include/mach/defBF522.h
+++ b/arch/blackfin/mach-bf527/include/mach/defBF522.h
@@ -1099,7 +1099,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length							*/
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid					*/
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call Adrress Matching Enabled		*/
+#define	GEN			0x0010		/* General Call Address Matching Enabled		*/
 
 /* TWI_SLAVE_STAT Masks															*/
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*)	*/
diff --git a/arch/blackfin/mach-bf538/include/mach/defBF538.h b/arch/blackfin/mach-bf538/include/mach/defBF538.h
index d27f81d..cb350a1 100644
--- a/arch/blackfin/mach-bf538/include/mach/defBF538.h
+++ b/arch/blackfin/mach-bf538/include/mach/defBF538.h
@@ -1767,7 +1767,7 @@
 #define	SADD_LEN	0x0002		/* Slave Address Length */
 #define	STDVAL		0x0004		/* Slave Transmit Data Valid */
 #define	NAK			0x0008		/* NAK/ACK* Generated At Conclusion Of Transfer */
-#define	GEN			0x0010		/* General Call	Adrress	Matching Enabled */
+#define	GEN			0x0010		/* General Call	Address	Matching Enabled */
 
 /* TWIx_SLAVE_STAT Masks								 */
 #define	SDIR		0x0001		/* Slave Transfer Direction (Transmit/Receive*) */
-- 
1.7.2.3

