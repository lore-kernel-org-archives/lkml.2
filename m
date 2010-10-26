Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab0JZT5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39474 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760123Ab0JZT5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:37 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/22] trivial: fix typos concerning "equal"
Date: Tue, 26 Oct 2010 21:57:05 +0200
Message-Id: <1288123039-22368-8-git-send-email-u.kleine-koenig@pengutronix.de>
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
 drivers/net/sis900.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index 5818368..5976d1d 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -36,7 +36,7 @@
    Rev 1.07.06 Nov.  7 2000 Jeff Garzik <jgarzik@pobox.com> some bug fix and cleaning
    Rev 1.07.05 Nov.  6 2000 metapirat<metapirat@gmx.de> contribute media type select by ifconfig
    Rev 1.07.04 Sep.  6 2000 Lei-Chun Chang added ICS1893 PHY support
-   Rev 1.07.03 Aug. 24 2000 Lei-Chun Chang (lcchang@sis.com.tw) modified 630E eqaulizer workaround rule
+   Rev 1.07.03 Aug. 24 2000 Lei-Chun Chang (lcchang@sis.com.tw) modified 630E equalizer workaround rule
    Rev 1.07.01 Aug. 08 2000 Ollie Lho minor update for SiS 630E and SiS 630E A1
    Rev 1.07    Mar. 07 2000 Ollie Lho bug fix in Rx buffer ring
    Rev 1.06.04 Feb. 11 2000 Jeff Garzik <jgarzik@pobox.com> softnet and init for kernel 2.4
-- 
1.7.2.3

