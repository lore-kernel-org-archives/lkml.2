Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1FUAzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:55:12 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:64715 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1FUAzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:55:10 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1308617708!22194589!1
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] svcsock.c: include sunrpc.h to quite sparse noise
Date: Mon, 20 Jun 2011 17:54:51 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <Trond.Myklebust@netapp.com>, <bfields@fieldses.org>, <neilb@suse.de>,
        <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106201754.51704.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the private header sunrpc.h to pickup the declaration of the
function svc_send_common to quiet the following sparse noise:

warning: symbol 'svc_send_common' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>

---

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index af04f77..f2cb5b8 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -51,6 +51,8 @@
 #include <linux/sunrpc/stats.h>
 #include <linux/sunrpc/xprt.h>
 
+#include "sunrpc.h"
+
 #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
 
 
