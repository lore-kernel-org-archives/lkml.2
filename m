Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1CPPQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:16:34 -0400
Received: from asset.uwaterloo.ca ([129.97.92.29]:43439 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1CPPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:16:29 -0400
Date: Wed, 16 Mar 2011 11:16:22 -0400
From: j223yang@asset.uwaterloo.ca
To: trond.myklebust@fys.uio.no
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch]xprt: remove redundant check 
Message-ID: <20110316151622.GA2932@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove redundant check, second hunk.

Signed-off-by: Jinqiu Yang <crindy646@gmail.com>
---
 xprt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt
--- a/net/sunrpc/xprt.c	2011-03-16 11:06:58.460039603 -0400
+++ b/net/sunrpc/xprt.c	2011-03-16 11:07:49.835164663 -0400
@@ -212,7 +212,7 @@ out_sleep:
 			task->tk_pid, xprt);
 	task->tk_timeout = 0;
 	task->tk_status = -EAGAIN;
-	if (req && req->rq_ntrans)
+	if (req->rq_ntrans)
 		rpc_sleep_on(&xprt->resend, task, NULL);
 	else
 		rpc_sleep_on(&xprt->sending, task, NULL);
