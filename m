Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab0JZT5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39447 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab0JZT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:28 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/22] trivial: fix typos concerning "already"
Date: Tue, 26 Oct 2010 21:56:58 +0200
Message-Id: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
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
 drivers/scsi/bfa/bfa_fcpim.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 33c8dd5..aabbf3d 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2092,7 +2092,7 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 
 	case BFA_IOIM_SM_ABORT:
 		/**
-		 * IO is alraedy being cleaned up implicitly
+		 * IO is already being cleaned up implicitly
 		 */
 		ioim->io_cbfn = __bfa_cb_ioim_abort;
 		break;
-- 
1.7.2.3

