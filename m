Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0IANlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:41:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38937 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab0IANlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:41:04 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging/trivial: fix typos concerning "through"
Date: Wed,  1 Sep 2010 15:40:27 +0200
Message-Id: <1283348427-6183-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283348427-6183-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1283348427-6183-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 drivers/staging/wlags49_h2/mdd.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index b50b7b0..5aa9eb8 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -1002,7 +1002,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define CFG_CONNECTION_MODE				0x0908		//controls the mode of the FW (ESS/AP/IBSS/ADHOC)
 #define CFG_IFB							0x0909		//byte wise copy of IFB
 #define CFG_MSF_TALLIES					0x090A		//MSF tallies (int's, rx and tx)
-#define CFG_CURRENT_LINK_STATUS			0x090B		//Latest link status got trough 0xF200 LinkEvent
+#define CFG_CURRENT_LINK_STATUS			0x090B		//Latest link status got through 0xF200 LinkEvent
 
 /*============================================================ INFORMATION FRAMES =========================*/
 #define CFG_INFO_FRAME_MIN				0xF000		//lowest value representing an Informatio Frame
-- 
1.7.1

