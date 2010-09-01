Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0IANlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:41:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38953 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab0IANl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:41:28 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging/trivial: fix typos concerning "address"
Date: Wed,  1 Sep 2010 15:40:24 +0200
Message-Id: <1283348427-6183-3-git-send-email-u.kleine-koenig@pengutronix.de>
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
 drivers/staging/tidspbridge/pmgr/dbll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 2340638..878aa50 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -1501,7 +1501,7 @@ static void release(struct dynamic_loader_initialize *this)
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 /**
  *  find_symbol_context - Basic symbol context structure
- * @address:		Symbol Adress
+ * @address:		Symbol Address
  * @offset_range:		Offset range where the search for the DSP symbol
  *			started.
  * @cur_best_offset:	Best offset to start looking for the DSP symbol
-- 
1.7.1

