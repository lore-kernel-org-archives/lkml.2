Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280Ab0JZT5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39478 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab0JZT5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:37 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/22] trivial: fix typos concerning "interest"
Date: Tue, 26 Oct 2010 21:57:11 +0200
Message-Id: <1288123039-22368-14-git-send-email-u.kleine-koenig@pengutronix.de>
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
 drivers/scsi/aic7xxx_old/aic7xxx.seq |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.seq b/drivers/scsi/aic7xxx_old/aic7xxx.seq
index 5997e7c..1565be9 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx.seq
+++ b/drivers/scsi/aic7xxx_old/aic7xxx.seq
@@ -1178,7 +1178,7 @@ notFound:
 /*
  * Retrieve an SCB by SCBID first searching the disconnected list falling
  * back to DMA'ing the SCB down from the host.  This routine assumes that
- * ARG_1 is the SCBID of interrest and that SINDEX is the position in the
+ * ARG_1 is the SCBID of interest and that SINDEX is the position in the
  * disconnected list to start the search from.  If SINDEX is SCB_LIST_NULL,
  * we go directly to the host for the SCB.
  */
-- 
1.7.2.3

