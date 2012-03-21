Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2CUTDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:03:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44925 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2CUTDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:03:18 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH] checkpatch: print how much the 80 char limit has been exceeded
Date: Wed, 21 Mar 2012 20:03:10 +0100
Message-Id: <1332356590-8218-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..1874197 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1734,7 +1734,7 @@ sub process {
 		    $length > 80)
 		{
 			WARN("LONG_LINE",
-			     "line over 80 characters\n" . $herecurr);
+			     "line over 80 characters, namely $length\n" . $herecurr);
 		}
 
 # check for spaces before a quoted newline
-- 
1.7.2.5

