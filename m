Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab0EQXat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:30:49 -0400
Received: from xenotime.net ([72.52.115.56]:50444 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756220Ab0EQX3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:29:10 -0400
Date: Mon, 17 May 2010 16:21:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Paul Fox <pgf@laptop.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/10] Documentation/sysrq.txt: update KEY_SYSRQ info
Message-ID: <12741384711202@xenotime.net>
In-Reply-To: <12741384711166@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

While setting up sysrq operation on the XO laptop (which lacks a SysRq
key), i realized that the documentation was quite out of date.

    Change documentation of SysRq to reflect current KEY_SYSRQ value.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/sysrq.txt |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- lnx-2634-docs.orig/Documentation/sysrq.txt
+++ lnx-2634-docs/Documentation/sysrq.txt
@@ -177,13 +177,13 @@ virtual console (ALT+Fn) and then back a
 
 *  I hit SysRq, but nothing seems to happen, what's wrong?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-There are some keyboards that send different scancodes for SysRq than the
-pre-defined 0x54. So if SysRq doesn't work out of the box for a certain
-keyboard, run 'showkey -s' to find out the proper scancode sequence. Then
-use 'setkeycodes <sequence> 84' to define this sequence to the usual SysRq
-code (84 is decimal for 0x54). It's probably best to put this command in a
-boot script. Oh, and by the way, you exit 'showkey' by not typing anything
-for ten seconds.
+There are some keyboards that produce a different keycode for SysRq than the
+pre-defined value of 99 (see KEY_SYSRQ in include/linux/input.h), or which
+don't have a SysRq key at all. In these cases, run 'showkey -s' to find an
+appropriate scancode sequence, and use 'setkeycodes <sequence> 99' to map
+this sequence to the usual SysRq code (e.g., 'setkeycodes e05b 99'). It's
+probably best to put this command in a boot script. Oh, and by the way, you
+exit 'showkey' by not typing anything for ten seconds.
 
 *  I want to add SysRQ key events to a module, how does it work?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- 

