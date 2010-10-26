Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346Ab0JZUAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:00:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39466 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042Ab0JZT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/22] trivial: fix typos concerning "select"
Date: Tue, 26 Oct 2010 21:57:18 +0200
Message-Id: <1288123039-22368-21-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 scripts/kconfig/confdata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 96110ea..f751381 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -923,7 +923,7 @@ static void randomize_choice_values(struct symbol *csym)
 	int cnt, def;
 
 	/*
-	 * If choice is mod then we may have more items slected
+	 * If choice is mod then we may have more items selected
 	 * and if no then no-one.
 	 * In both cases stop.
 	 */
-- 
1.7.2.3

