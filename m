Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab1ESMhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:37:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54721 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab1ESMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vQ0W9iJwstdq1ChuJUgtdylFKY2a027QtAKkbhARZakBXRtWARi+8gPsIqGmQgTn2q
         4NhhbBGhBQNM5rJG/0DL9DTjm9aOax3NBNpLAXWxIhzE1QNJ1CODkBORNKT87mfy+MMb
         lnJxeEQcZQc4aS8ltrNBCnqjiYBdIbX4rQu5Y=
Subject: [PATCH 1/2] gconfig: enable rules hint for main treeviews
From: Eduardo Silva <edsiper@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 08:37:01 -0400
Message-ID: <1305808621.11775.3.camel@monotop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the large amount of rows in the treeviews, is difficult to
match columns with rows, setting the rules hint to 'true' allows the
treeview to alternate background colors in the rows making the data
more readable.

Signed-off-by: Eduardo Silva <edsiper@gmail.com>
---
 scripts/kconfig/gconf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 4558961..0c8db7d 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -253,7 +253,7 @@ void init_left_tree(void)
 
 	gtk_tree_view_set_model(view, model1);
 	gtk_tree_view_set_headers_visible(view, TRUE);
-	gtk_tree_view_set_rules_hint(view, FALSE);
+	gtk_tree_view_set_rules_hint(view, TRUE);
 
 	column = gtk_tree_view_column_new();
 	gtk_tree_view_append_column(view, column);
@@ -298,7 +298,7 @@ void init_right_tree(void)
 
 	gtk_tree_view_set_model(view, model2);
 	gtk_tree_view_set_headers_visible(view, TRUE);
-	gtk_tree_view_set_rules_hint(view, FALSE);
+	gtk_tree_view_set_rules_hint(view, TRUE);
 
 	column = gtk_tree_view_column_new();
 	gtk_tree_view_append_column(view, column);
-- 
1.7.4.1



