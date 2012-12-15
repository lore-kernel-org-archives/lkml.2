Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2LOQVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 11:21:19 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47362 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab2LOQVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 11:21:17 -0500
From: zwu.kernel@gmail.com
To: shemminger@vyatta.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] ip: add the type 'vxlan' in the output of "ip link help"
Date: Sun, 16 Dec 2012 00:21:08 +0800
Message-Id: <1355588468-4964-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121516-7182-0000-0000-000003D094A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  The new type 'vxlan' is added in the output of "ip link help"

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 ip/iplink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index d73c705..5ff8f85 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -84,7 +84,7 @@ void iplink_usage(void)
 	if (iplink_have_newlink()) {
 		fprintf(stderr, "\n");
 		fprintf(stderr, "TYPE := { vlan | veth | vcan | dummy | ifb | macvlan | can |\n");
-		fprintf(stderr, "          bridge | ipoib | ip6tnl | ipip | sit }\n");
+		fprintf(stderr, "          bridge | ipoib | ip6tnl | ipip | sit | vxlan }\n");
 	}
 	exit(-1);
 }
-- 
1.7.2.5

