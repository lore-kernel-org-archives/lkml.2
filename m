Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2H2Njb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:39:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59894 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab2H2Nj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:39:28 -0400
From: yan <clouds.yan@gmail.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] watchdog: fix a compiler warning of test program
Date: Wed, 29 Aug 2012 21:39:05 +0800
Message-Id: <1346247545-3433-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixs the following compiler warning:

Documentation/watchdog/src/watchdog-test.c:34:6: \
warning: no previous prototype for ‘term’ [-Wmissing-prototypes]

Signed-off-by: yan <clouds.yan@gmail.com>
---
 Documentation/watchdog/src/watchdog-test.c |    2 +-
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
1.7.9.5

