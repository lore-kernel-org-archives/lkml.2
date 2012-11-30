Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab2K3RFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:05:51 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:57177 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758832Ab2K3RFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:05:48 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: maxk@qti.qualcomm.com
Cc: netdev@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: fix bouncing tun/tap entries
Date: Fri, 30 Nov 2012 18:05:40 +0100
Message-Id: <1354295140-6355-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delivery to the following recipient failed permanently:

     vtun@office.satix.net

Technical details of permanent failure:
DNS Error: Domain name not found

Of course:
$ host office.satix.net
Host office.satix.net not found: 3(NXDOMAIN)

===========

And "Change of Email Address Notification":
Old Address        New Address           Email Subject
------------------------------------------------------
maxk@qualcomm.com  maxk@qti.qualcomm.com "tuntap: multiqueue...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Maxim Krasnyansky <maxk@qti.qualcomm.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 61b2e14..75d3b88 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7696,8 +7696,7 @@ S:	Maintained
 F:	drivers/net/ethernet/dec/tulip/
 
 TUN/TAP driver
-M:	Maxim Krasnyansky <maxk@qualcomm.com>
-L:	vtun@office.satix.net
+M:	Maxim Krasnyansky <maxk@qti.qualcomm.com>
 W:	http://vtun.sourceforge.net/tun
 S:	Maintained
 F:	Documentation/networking/tuntap.txt
-- 
1.8.0.1


