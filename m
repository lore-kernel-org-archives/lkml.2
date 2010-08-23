Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab0HWRZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:25:34 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40999 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0HWRZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:25:31 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: linux-raid@vger.kernel.org
Subject: [PATCH] lib/raid6: ignore generated files
CC: linux-kernel@vger.kernel.org
X-Yow: Yow!  Are we laid back yet?
Date: Mon, 23 Aug 2010 19:25:30 +0200
Message-ID: <m2d3t9z1f9.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 lib/raid6/.gitignore |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 lib/raid6/.gitignore

diff --git a/lib/raid6/.gitignore b/lib/raid6/.gitignore
new file mode 100644
index 0000000..730e5ec
--- /dev/null
+++ b/lib/raid6/.gitignore
@@ -0,0 +1,12 @@
+int1.c
+int2.c
+int4.c
+int8.c
+int16.c
+int32.c
+altivec1.c
+altivec2.c
+altivec4.c
+altivec8.c
+tables.c
+mktables
-- 
1.7.2.2

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
