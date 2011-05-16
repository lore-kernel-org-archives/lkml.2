Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1EPTRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:17:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57456 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753475Ab1EPTRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:17:06 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1/aoVMt+27aLY+w3r5fUHpgUQ34fs3mXATYqHa0YI
	pYnA9/5fG3kjO+
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <trivial@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH trivial] timers-howto: fix a typo ("unsgined")
Date: Mon, 16 May 2011 21:15:34 +0200
Message-Id: <1305573335-28361-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.5.134.g1c08b
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 Documentation/timers/timers-howto.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/timers/timers-howto.txt b/Documentation/timers/timers-howto.txt
index c9ef29d..038f8c7 100644
--- a/Documentation/timers/timers-howto.txt
+++ b/Documentation/timers/timers-howto.txt
@@ -24,7 +24,7 @@ ATOMIC CONTEXT:
 
 	ndelay(unsigned long nsecs)
 	udelay(unsigned long usecs)
-	mdelay(unsgined long msecs)
+	mdelay(unsigned long msecs)
 
 	udelay is the generally preferred API; ndelay-level
 	precision may not actually exist on many non-PC devices.
-- 
1.7.5.134.g1c08b

