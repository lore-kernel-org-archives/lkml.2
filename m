Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab1FJXQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:16:06 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:41146 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab1FJXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:16:03 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1307747762!22120639!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/ipv4/ipconfig.c: local symbols should be static
Date: Fri, 10 Jun 2011 16:15:52 -0700
User-Agent: KMail/1.9.9
CC: <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>, <pekkas@netcore.fi>,
        <jmorris@namei.org>, <yoshfuji@linux-ipv6.org>, <kaber@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106101615.52586.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol ic_dev_xid is only used in this file and should be
marked static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Pekka Savola (ipv6)" <pekkas@netcore.fi>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>

---

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index ab7e554..66e4fae7 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -140,7 +140,7 @@ __be32 ic_servaddr = NONE;	/* Boot server IP address */
 __be32 root_server_addr = NONE;	/* Address of NFS server */
 u8 root_server_path[256] = { 0, };	/* Path to mount as root */
 
-u32 ic_dev_xid;		/* Device under configuration */
+static u32 ic_dev_xid;		/* Device under configuration */
 
 /* vendor class identifier */
 static char vendor_class_identifier[253] __initdata;
