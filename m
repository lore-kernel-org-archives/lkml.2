Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1LBUVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:21:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47439 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1LBUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:21:33 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Date: Fri,  2 Dec 2011 21:20:11 +0100
Message-Id: <1322857211-26654-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] serial/documentation: fix name of DCD cpp symbol
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 Documentation/serial/driver |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/serial/driver b/Documentation/serial/driver
index 77ba0af..0a25a91 100644
--- a/Documentation/serial/driver
+++ b/Documentation/serial/driver
@@ -101,7 +101,7 @@ hardware.
 	Returns the current state of modem control inputs.  The state
 	of the outputs should not be returned, since the core keeps
 	track of their state.  The state information should include:
-		- TIOCM_DCD	state of DCD signal
+		- TIOCM_CAR	state of DCD signal
 		- TIOCM_CTS	state of CTS signal
 		- TIOCM_DSR	state of DSR signal
 		- TIOCM_RI	state of RI signal
-- 
1.7.7.3

