Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab2JWUFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52728 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614Ab2JWUE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:04:56 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rob Landley <rob@landley.net>
Subject: [PATCH 005/193] Documentation/networking: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:18 -0700
Message-Id: <1351022666-6960-6-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Rob Landley <rob@landley.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/networking/cs89x0.txt |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/cs89x0.txt b/Documentation/networking/cs89x0.txt
index c725d33..cc91a15 100644
--- a/Documentation/networking/cs89x0.txt
+++ b/Documentation/networking/cs89x0.txt
@@ -386,15 +386,13 @@ tristate 'CS89x0 support' CONFIG_CS89x0
 
 Example:
 
-     if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-       tristate 'ICL EtherTeam 16i/32 support' CONFIG_ETH16I
-     fi
+     tristate 'ICL EtherTeam 16i/32 support' CONFIG_ETH16I
 
      tristate 'CS89x0 support' CONFIG_CS89x0
 
      tristate 'NE2000/NE1000 support' CONFIG_NE2000
-     if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
-       tristate 'NI5210 support' CONFIG_NI52
+
+     tristate 'NI5210 support' CONFIG_NI52
 
 
 b.) In /usr/src/linux/drivers/net/Makefile, add the following lines: 
-- 
1.7.9.5

