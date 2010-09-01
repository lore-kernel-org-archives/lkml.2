Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0IANlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:41:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38942 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0IANlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:41:12 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging/trivial: fix typos concerning "management"
Date: Wed,  1 Sep 2010 15:40:26 +0200
Message-Id: <1283348427-6183-5-git-send-email-u.kleine-koenig@pengutronix.de>
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
 drivers/staging/spectra/flash.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/spectra/flash.h b/drivers/staging/spectra/flash.h
index 5ed0580..e59cf4e 100644
--- a/drivers/staging/spectra/flash.h
+++ b/drivers/staging/spectra/flash.h
@@ -104,7 +104,7 @@ struct flash_cache_tag {
 };
 
 /*
- *Data structure for each list node of the managment table
+ *Data structure for each list node of the management table
  * used for the Level 2 Cache. Each node maps one logical NAND block.
  */
 struct spectra_l2_cache_list {
-- 
1.7.1

