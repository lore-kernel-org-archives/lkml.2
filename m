Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2HFBBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:01:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37591 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2HFBBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:01:25 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 01:01:23 +0000
Message-ID: <CAGh4K3LLy0fnFMJ-e+yqCM7cpONo41-cP_o7dQvsAesd-hdvuQ@mail.gmail.com>
Subject: [PATCH]: With no attatchment NOT SPAM, a REWRITE
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys, this should work now.
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
Thanks,
-- 
Christopher
P.S. Copy betwwen the two dashed lines.
