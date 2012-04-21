Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2DUW1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 18:27:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49755 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2DUW1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 18:27:19 -0400
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, dwmw2@infradead.org, ben@decadent.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH] linux-firmware: add README
Date: Sun, 22 Apr 2012 00:27:14 +0200
Message-Id: <1335047234-5100-1-git-send-email-xose.vazquez@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

basic info about how to submit files or patches.

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 README

diff --git a/README b/README
new file mode 100644
index 0000000..36c47b2
--- /dev/null
+++ b/README
@@ -0,0 +1,38 @@
+
+	Linux firmware
+	==============
+
+  <http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git>
+
+  git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
+
+This repository contains all these firmware images which have been
+extracted from older drivers, as well various new firmware images which
+we were never permitted to include in a GPL'd work, but which we _have_
+been permitted to redistribute under separate cover.
+
+To submit firmware to this repository, please send either a git binary
+diff or preferably a git pull request to:
+      David Woodhouse <dwmw2@infradead.org>
+      Ben Hutchings <ben@decadent.org.uk>
+and also cc: to related mailing lists.
+
+Your commit should include an update to the WHENCE file clearly
+identifying the licence under which the firmware is available, and
+that it is redistributable. If the licence is long and involved, it's
+permitted to include it in a separate file and refer to it from the
+WHENCE file. 
+And if it were possible, a changelog of the firmware itself.
+
+Ideally, your commit should contain a Signed-Off-By: from someone
+authoritative on the licensing of the firmware in question (i.e. from
+within the company that owns the code).
+
+
+WARNING:
+=======
+
+Don't send any "CONFIDENTIALITY STATEMENT" in your e-mail, patch or
+request. Otherwise your firmware _will never be accepted_.
+
+Maintainers are really busy, so don't expect a prompt reply.
-- 
1.7.6.5

