Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0I1Q5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:57:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58865 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab0I1Q5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:57:17 -0400
Date: Tue, 28 Sep 2010 09:56:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        davem@davemloft.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        <masa-korg@dsn.okisemi.com>
Subject: [PATCH -next] pch_gbe: add header files
Message-Id: <20100928095643.18c5020f.randy.dunlap@oracle.com>
In-Reply-To: <20100928141823.8c61000e.sfr@canb.auug.org.au>
References: <20100928141823.8c61000e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors, more header files needed.

drivers/net/pch_gbe/pch_gbe_main.c:965: error: implicit declaration of function 'tcp_hdr'
drivers/net/pch_gbe/pch_gbe_main.c:965: error: invalid type argument of '->' (have 'int')
drivers/net/pch_gbe/pch_gbe_main.c:968: error: invalid type argument of '->' (have 'int')
drivers/net/pch_gbe/pch_gbe_main.c:976: error: implicit declaration of function 'udp_hdr'
drivers/net/pch_gbe/pch_gbe_main.c:976: error: invalid type argument of '->' (have 'int')
drivers/net/pch_gbe/pch_gbe_main.c:980: error: invalid type argument of '->' (have 'int')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/pch_gbe/pch_gbe.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20100927.orig/drivers/net/pch_gbe/pch_gbe.h
+++ linux-next-20100927/drivers/net/pch_gbe/pch_gbe.h
@@ -31,6 +31,8 @@
 #include <linux/ethtool.h>
 #include <linux/vmalloc.h>
 #include <net/ip.h>
+#include <net/tcp.h>
+#include <net/udp.h>
 
 /**
  * pch_gbe_regs_mac_adr - Structure holding values of mac address registers
