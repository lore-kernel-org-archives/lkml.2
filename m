Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1AHNFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 08:05:21 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:32850 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1AHNFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 08:05:19 -0500
Date: Sat, 8 Jan 2011 14:05:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Subject: [EXAMPLE PATCH 2/2] x86: start to utilize kbuild asm-generic
	support
Message-ID: <20110108130518.GB25461@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110108130302.GA21698@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fd70bb929b975f02879860aefb48f0b0a14d7aab Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 8 Jan 2011 13:50:52 +0100
Subject: [PATCH 2/2] x86: start to utilize kbuild asm-generic support

---
 arch/x86/.gitignore             |    1 +
 arch/x86/include/asm-generic    |    3 +++
 arch/x86/include/asm/termbits.h |    1 -
 arch/x86/include/asm/termios.h  |    1 -
 4 files changed, 4 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm-generic
 delete mode 100644 arch/x86/include/asm/termbits.h
 delete mode 100644 arch/x86/include/asm/termios.h

diff --git a/arch/x86/.gitignore b/arch/x86/.gitignore
index 0280790..1448346 100644
--- a/arch/x86/.gitignore
+++ b/arch/x86/.gitignore
@@ -1,3 +1,4 @@
 boot/compressed/vmlinux
 tools/test_get_len
+include/generated
 
diff --git a/arch/x86/include/asm-generic b/arch/x86/include/asm-generic
new file mode 100644
index 0000000..50aa036
--- /dev/null
+++ b/arch/x86/include/asm-generic
@@ -0,0 +1,3 @@
+# generic headers from include/asm-generic/
+termbits.h
+termios.h
diff --git a/arch/x86/include/asm/termbits.h b/arch/x86/include/asm/termbits.h
deleted file mode 100644
index 3935b10..0000000
--- a/arch/x86/include/asm/termbits.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termbits.h>
diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
deleted file mode 100644
index 280d78a..0000000
--- a/arch/x86/include/asm/termios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/termios.h>
-- 
1.6.0.6

