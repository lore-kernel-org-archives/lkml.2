Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1G2RL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:11:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35244 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1G2RLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:11:25 -0400
Subject: [PATCH] net: xprt.c: htmldocs warning correction
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: David Miller <davem@davemloft.net>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: vitalivanov@gmail.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 20:11:19 +0300
Message-ID: <1311959479.2242.41.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description for parameter 'xprt'.

Warning(/net/sunrpc/xprt.c:196): No description found for parameter 'xprt'

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 net/sunrpc/xprt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 9b6a4d1..366b5f4 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -186,6 +186,7 @@ EXPORT_SYMBOL_GPL(xprt_load_transport);
 
 /**
  * xprt_reserve_xprt - serialize write access to transports
+ * @xprt: transport with waiting tasks
  * @task: task that is requesting access to the transport
  *
  * This prevents mixing the payload of separate requests, and prevents
-- 
1.7.6.347.g4db0d



