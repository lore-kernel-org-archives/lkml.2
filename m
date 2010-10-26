Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392Ab0JZUAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:00:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39459 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab0JZT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/22] trivial: fix typos concerning "instead"
Date: Tue, 26 Oct 2010 21:57:10 +0200
Message-Id: <1288123039-22368-13-git-send-email-u.kleine-koenig@pengutronix.de>
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
 security/apparmor/include/match.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
index 734a6d3..e00c3c7 100644
--- a/security/apparmor/include/match.h
+++ b/security/apparmor/include/match.h
@@ -27,7 +27,7 @@
  * The format used for transition tables is based on the GNU flex table
  * file format (--tables-file option; see Table File Format in the flex
  * info pages and the flex sources for documentation). The magic number
- * used in the header is 0x1B5E783D insted of 0xF13C57B1 though, because
+ * used in the header is 0x1B5E783D instead of 0xF13C57B1 though, because
  * the YY_ID_CHK (check) and YY_ID_DEF (default) tables are used
  * slightly differently (see the apparmor-parser package).
  */
-- 
1.7.2.3

