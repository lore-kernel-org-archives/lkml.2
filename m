Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1C1Qa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1C1Qaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eVQhoVcXvoVncDQhMxQcAOZ7+uMDpkIhZ5papSqqrdAUGHr2RxvCkNgZmP4nqR3Mqg
         eIa45IsF0W1qvJRWfX9B9nfFeEALfzNyUGuQoybSQV0g/VK1Y4XvUK+uv/37g2zJXM0P
         r8svPNOHhEtMp1Cnih1IlCEOq1CFe67FlX34g=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 24/25]net Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:47 -0700
Message-Id: <1301329788-3423-25-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/caif/caif_dev.c               |    1 -
 net/caif/chnl_net.c               |    1 -
 net/ipv4/gre.c                    |    1 -
 net/netfilter/ipset/ip_set_core.c |    1 -
 net/netfilter/xt_set.c            |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index a42a408..298ba6d 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -11,7 +11,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 6008d6d..bfeaca1 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -7,7 +7,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
 
-#include <linux/version.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/net/ipv4/gre.c b/net/ipv4/gre.c
index c6933f2..9dbe108 100644
--- a/net/ipv4/gre.c
+++ b/net/ipv4/gre.c
@@ -16,7 +16,6 @@
 #include <linux/skbuff.h>
 #include <linux/in.h>
 #include <linux/netdevice.h>
-#include <linux/version.h>
 #include <linux/spinlock.h>
 #include <net/protocol.h>
 #include <net/gre.h>
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index d6b4823..68b76d2 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -17,7 +17,6 @@
 #include <linux/spinlock.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
-#include <linux/version.h>
 #include <net/netlink.h>
 
 #include <linux/netfilter.h>
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index 061d48c..bad5a59 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/skbuff.h>
-#include <linux/version.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_set.h>
-- 
1.7.4.1

