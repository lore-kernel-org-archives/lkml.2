Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0KWQM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 11:12:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59569 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0KWQM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 11:12:57 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [PATCH] trivial: make comment about vs{n,cn,}printf more understandable
Date: Tue, 23 Nov 2010 17:12:45 +0100
Message-Id: <1290528765-25057-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

"You probably want ... instead." sounds like a recommendation better
not to use the v... functions.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 lib/vsprintf.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c150d3d..ec43171 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1279,8 +1279,7 @@ qualifier:
  * return is greater than or equal to @size, the resulting
  * string is truncated.
  *
- * Call this function if you are already dealing with a va_list.
- * You probably want snprintf() instead.
+ * If you're not already dealing with a va_list better use snprintf().
  */
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
@@ -1454,8 +1453,7 @@ EXPORT_SYMBOL(vsnprintf);
  * the @buf not including the trailing '\0'. If @size is <= 0 the function
  * returns 0.
  *
- * Call this function if you are already dealing with a va_list.
- * You probably want scnprintf() instead.
+ * If you're not already dealing with a va_list better use scnprintf().
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
@@ -1534,8 +1532,7 @@ EXPORT_SYMBOL(scnprintf);
  * into @buf. Use vsnprintf() or vscnprintf() in order to avoid
  * buffer overflows.
  *
- * Call this function if you are already dealing with a va_list.
- * You probably want sprintf() instead.
+ * If you're not already dealing with a va_list better use sprintf().
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-- 
1.7.2.3

