Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0IKFpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:45:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0IKFpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dbOnIfdHCAIQJSIy/rTUfIemUhsyu41G9T+/0zeIJKQNxiDWrpyjtxf39y6oCgerNL
         wZNpFdCL4UqB31GiF1Kz7hg0i00uWaXNnGIWOAPG5n9NDc8Ctns7RNhsnYiAIomIxzxp
         TwzCU4qGlukYGr76bvpUIwESKp0916PQD+qVQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 04/11]net/ipv4/tcp_illinois.c Update broken web addresses.
Date: Fri, 10 Sep 2010 22:45:56 -0700
Message-Id: <1284183963-8474-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
References: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/ipv4/tcp_illinois.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 1eba160..8bedf6c 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -1,12 +1,12 @@
 /*
  * TCP Illinois congestion control.
  * Home page:
- *	http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html
+ * http://web.archive.org/web/*/http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html	
  *
  * The algorithm is described in:
  * "TCP-Illinois: A Loss and Delay-Based Congestion Control Algorithm
  *  for High-Speed Networks"
- * http://www.ews.uiuc.edu/~shaoliu/papersandslides/liubassri06perf.pdf
+ * http://www.ifp.illinois.edu/~srikant/Papers/liubassri06perf.pdf
  *
  * Implemented from description in paper and ns-2 simulation.
  * Copyright (C) 2007 Stephen Hemminger <shemminger@linux-foundation.org>
-- 
1.7.2.1

