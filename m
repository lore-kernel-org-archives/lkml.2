Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2HFBwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:52:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51028 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab2HFBwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:52:22 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 01:52:20 +0000
Message-ID: <CAGh4K3+RODO0zuDThZKKzBCLexXa1M7qYVUu6knciruZ0KWGRQ@mail.gmail.com>
Subject: [PATCH]: Mac80211 Driver patch
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch for Mac80211, and no this is not spam, so do not ignore my
e-mails. This is a patch, so copy this into your favorite text editor
and save it as test.patch. Let the maintainers read and know! By the
way, it is under the first -- line and to the 2nd to last line. :)
--
--- main.c	2012-07-21 20:58:29.000000000 +0000
+++ mainnew.c	2012-08-05 20:00:37.000000000 +0000
@@ -32,7 +32,7 @@
 #include "led.h"
 #include "cfg.h"
 #include "debugfs.h"
-
+#include "net/rfkill/rfkill.h"
 static struct lock_class_key ieee80211_rx_skb_queue_class;

 void ieee80211_configure_filter(struct ieee80211_local *local)
@@ -183,6 +183,7 @@
 		 *
 		 */
 		/* WARN_ON(ret); */
+		WARN_ON(1)
 	}

 	return ret;
--
-- 
Christopher
