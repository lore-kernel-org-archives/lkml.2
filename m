Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2G0DwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:52:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57889 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2G0DwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:52:20 -0400
From: Jerry Snitselaar <dev@snitselaar.org>
To: linux-kernel@vger.kernel.org
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org
Subject: [PATCH] watchdog: watchdog-test: make term() static
Date: Thu, 26 Jul 2012 20:52:09 -0700
Message-Id: <1343361129-8802-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.12.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 3.5 warning during build 'no previous prototype for term'. Since it
is only used in watchdog-test.c make term() static.

Signed-off-by: Jerry Snitselaar <dev@snitselaar.org>
---
 Documentation/watchdog/src/watchdog-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/watchdog/src/watchdog-test.c b/Documentation/watchdog/src/watchdog-test.c
index 73ff5cc..3da8229 100644
--- a/Documentation/watchdog/src/watchdog-test.c
+++ b/Documentation/watchdog/src/watchdog-test.c
@@ -31,7 +31,7 @@ static void keep_alive(void)
  * or "-e" to enable the card.
  */
 
-void term(int sig)
+static void term(int sig)
 {
     close(fd);
     fprintf(stderr, "Stopping watchdog ticks...\n");
-- 
1.7.12.rc0

