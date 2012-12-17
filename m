Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2LQOiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:38:01 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37253 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2LQOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:37:48 -0500
Date: Mon, 17 Dec 2012 22:37:51 +0800
From: Wang YanQing <udknight@gmail.com>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
Subject: [PATCH] kconfig:lxdialog: remove duplicate code
Message-ID: <20121217143751.GA16993@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	rdunlap@xenotime.net, bp@alien8.de, yann.morin.1998@free.fr,
	sakiwit@gmail.com, lacombar@gmail.com,
	lucas.demarchi@profusion.mobi, dave@gnu.org,
	paul.gortmaker@windriver.com, crquan@gmail.com, bpoirier@suse.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dialog.h has two line the same below:
extern char dialog_input_result[];
This patch remove one of them.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/lxdialog/dialog.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/kconfig/lxdialog/dialog.h b/scripts/kconfig/lxdialog/dialog.h
index ee17a52..307022a 100644
--- a/scripts/kconfig/lxdialog/dialog.h
+++ b/scripts/kconfig/lxdialog/dialog.h
@@ -221,7 +221,6 @@ int dialog_menu(const char *title, const char *prompt,
 		const void *selected, int *s_scroll);
 int dialog_checklist(const char *title, const char *prompt, int height,
 		     int width, int list_height);
-extern char dialog_input_result[];
 int dialog_inputbox(const char *title, const char *prompt, int height,
 		    int width, const char *init);
 
-- 
1.7.11.1.116.g8228a23
