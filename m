Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1JSMdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:33:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55862 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1JSMdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:33:11 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Wolfram Sang <w.sang@pengutronix.de>,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH] checkpatch: improve error message for p1-check
Date: Wed, 19 Oct 2011 14:33:03 +0200
Message-Id: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.6.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old error message was not precise. State now explicitly that the
prefix exists as a file/directory. Also change the conclusion ("appears
to be") into an instruction ("make sure").

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3dfc471..4bb4f88 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1506,7 +1506,7 @@ sub process {
 			if (!$file && $tree && $p1_prefix ne '' &&
 			    -e "$root/$p1_prefix") {
 				WARN("PATCH_PREFIX",
-				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
+				     "patch prefix '$p1_prefix' exists as file/directory. Make sure this isn't a -p0 patch\n");
 			}
 
 			if ($realfile =~ m@^include/asm/@) {
-- 
1.7.6.3

