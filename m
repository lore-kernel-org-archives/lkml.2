Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2GIKYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:24:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37972 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752932Ab2GIKYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:24:20 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1+F+ghz2b6F4jROS/JzXxXT1YNUUu1JinQO+TpxRT
	Zr3PBUwZJENSjz
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <jansimon.moeller@gmx.de>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Trivial: Fix typo on Documentation/dynamic-debug-howto.txt
Date: Mon,  9 Jul 2012 12:23:02 +0200
Message-Id: <1341829382-32540-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <jansimon.moeller@gmx.de>

Signed-off-by: Jan-Simon Möller <jansimon.moeller@gmx.de>
Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/dynamic-debug-howto.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 6e16849..5250064 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -242,7 +242,7 @@ Debug Messages at Module Initialization Time
 
 When "modprobe foo" is called, modprobe scans /proc/cmdline for
 foo.params, strips "foo.", and passes them to the kernel along with
-params given in modprobe args or /etc/modprob.d/*.conf files,
+params given in modprobe args or /etc/modprobe.d/*.conf files,
 in the following order:
 
 1. # parameters given via /etc/modprobe.d/*.conf
-- 
1.7.3.4

