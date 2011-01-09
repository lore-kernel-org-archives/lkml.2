Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab1AITaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 14:30:23 -0500
Received: from pqueuea.post.tele.dk ([193.162.153.9]:40193 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab1AITaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 14:30:22 -0500
Date: Sun, 9 Jan 2011 20:29:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
Subject: [EXAMPLE PATCH 2/2] x86: start to utilize kbuild asm-generic
	support
Message-ID: <20110109192957.GB12403@merkur.ravnborg.org>
References: <20110108130302.GA21698@merkur.ravnborg.org> <20110109192707.GA12387@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109192707.GA12387@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e9405a7193563f948d293cfb4b2c0845c1ad54cc Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 9 Jan 2011 09:29:57 +0100
Subject: [PATCH 2/2] x86: start to utilize kbuild asm-generic support

---
 arch/x86/include/asm/Kbuild     |    6 ++++++
 arch/x86/include/asm/rtc.h      |    1 -
 arch/x86/include/asm/termbits.h |    1 -
 arch/x86/include/asm/termios.h  |    1 -
 4 files changed, 6 insertions(+), 3 deletions(-)
 delete mode 100644 arch/x86/include/asm/rtc.h
 delete mode 100644 arch/x86/include/asm/termbits.h
 delete mode 100644 arch/x86/include/asm/termios.h

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 6fa90a8..52bf61c 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -23,3 +23,9 @@ header-y += unistd_32.h
 header-y += unistd_64.h
 header-y += vm86.h
 header-y += vsyscall.h
+
+# generic headers from include/asm-generic/
+generic-y += termios.h
+generic-y += termbits.h
+generic-y += rtc.h
+
diff --git a/arch/x86/include/asm/rtc.h b/arch/x86/include/asm/rtc.h
deleted file mode 100644
index f71c3b0..0000000
--- a/arch/x86/include/asm/rtc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/rtc.h>
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

