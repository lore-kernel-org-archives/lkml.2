Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1FIUOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:14:05 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:53754 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab1FIUOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:14:01 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1307650435!12606939!18
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ep93xx_eth: Update MAINTAINERS
Date: Thu, 9 Jun 2011 13:13:25 -0700
User-Agent: KMail/1.9.9
CC: <kernel@wantstofly.org>, <akpm@linux-foundation.org>, <joe@perches.com>,
        <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106091313.25840.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert stated that he has been short on time lately. Since I'm maintaining
the ep93xx core stuff, I'm willing to also take over maintaining the Ethernet
driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>

---

diff --git a/MAINTAINERS b/MAINTAINERS
index d1220da..a32f2ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1740,7 +1740,7 @@ S:	Supported
 F:	drivers/net/enic/
 
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
-M:	Lennert Buytenhek <kernel@wantstofly.org>
+M:	Hartley Sweeten <hsweeten@visionengravers.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/arm/ep93xx_eth.c
