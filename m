Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab2DYAiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:38:54 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:28895 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2DYAiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:38:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1335314326!3555994!5
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] crush: include header for global symbols
Date: Tue, 24 Apr 2012 17:38:37 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>, <ceph-devel@vger.kernel.org>,
        <sage@newdream.net>, <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204241738.38280.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the header to pickup the definitions of the global symbols.

Quiets the following sparse warnings:

warning: symbol 'crush_find_rule' was not declared. Should it be static?
warning: symbol 'crush_do_rule' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Sage Weil <sage@newdream.net>
Cc: "David S. Miller" <davem@davemloft.net>

---

diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 854ac53..363f8f7 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -20,6 +20,7 @@
 
 #include <linux/crush/crush.h>
 #include <linux/crush/hash.h>
+#include <linux/crush/mapper.h>
 
 /*
  * Implement the core CRUSH mapping algorithm.
