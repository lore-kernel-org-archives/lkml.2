Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2GXUMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:12:48 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46548 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2GXUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:12:20 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2 1/2] menuconfig: add u, d, q command keys in text boxes
Date: Tue, 24 Jul 2012 16:12:02 -0400
Message-Id: <1343160723-14308-1-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <500EDDAF.4040506@xenotime.net>
References: <500EDDAF.4040506@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They function just like they do in less(1).

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 scripts/kconfig/lxdialog/textbox.c |    3 +++
 scripts/kconfig/mconf.c            |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
index 154c2dd..4e5de60 100644
--- a/scripts/kconfig/lxdialog/textbox.c
+++ b/scripts/kconfig/lxdialog/textbox.c
@@ -129,6 +129,7 @@ do_resize:
 		case 'e':
 		case 'X':
 		case 'x':
+		case 'q':
 			delwin(box);
 			delwin(dialog);
 			return 0;
@@ -190,6 +191,7 @@ do_resize:
 			break;
 		case 'B':	/* Previous page */
 		case 'b':
+		case 'u':
 		case KEY_PPAGE:
 			if (begin_reached)
 				break;
@@ -214,6 +216,7 @@ do_resize:
 			break;
 		case KEY_NPAGE:	/* Next page */
 		case ' ':
+		case 'd':
 			if (end_reached)
 				break;
 
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index f606738..f584a28 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -105,10 +105,10 @@ static const char mconf_readme[] = N_(
 "Text Box    (Help Window)\n"
 "--------\n"
 "o  Use the cursor keys to scroll up/down/left/right.  The VI editor\n"
-"   keys h,j,k,l function here as do <SPACE BAR> and <B> for those\n"
-"   who are familiar with less and lynx.\n"
+"   keys h,j,k,l function here as do <u>, <d>, <SPACE BAR> and <B> for \n"
+"   those who are familiar with less and lynx.\n"
 "\n"
-"o  Press <E>, <X>, <Enter> or <Esc><Esc> to exit.\n"
+"o  Press <E>, <X>, <q>, <Enter> or <Esc><Esc> to exit.\n"
 "\n"
 "\n"
 "Alternate Configuration Files\n"
-- 
1.7.7

