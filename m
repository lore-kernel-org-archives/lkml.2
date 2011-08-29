Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1H2Stq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:49:46 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:57055 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754471Ab1H2Stn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:49:43 -0400
Date: Mon, 29 Aug 2011 11:49:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        davem@davemloft.net
Subject: [PATCH -next] net: fix Makefile typos & build errors
Message-Id: <20110829114940.4d29febc.rdunlap@xenotime.net>
In-Reply-To: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
References: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix many (randconfig) PPP build errors by fixing typos in
drivers/net/Makefile.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/net/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20110829.orig/drivers/net/Makefile
+++ linux-next-20110829/drivers/net/Makefile
@@ -35,7 +35,7 @@ obj-$(CONFIG_HIPPI) += hippi/
 obj-$(CONFIG_HAMRADIO) += hamradio/
 obj-$(CONFIG_IRDA) += irda/
 obj-$(CONFIG_PLIP) += plip/
-onj-$(CONFIG_PPP) += ppp/
+obj-$(CONFIG_PPP) += ppp/
 obj-$(CONFIG_PPP_ASYNC) += ppp/
 obj-$(CONFIG_PPP_BSDCOMP) += ppp/
 obj-$(CONFIG_PPP_DEFLATE) += ppp/
@@ -44,10 +44,10 @@ obj-$(CONFIG_PPP_SYNC_TTY) += ppp/
 obj-$(CONFIG_PPPOE) += ppp/
 obj-$(CONFIG_PPPOL2TP) += ppp/
 obj-$(CONFIG_PPTP) += ppp/
-onj-$(CONFIG_SLIP) += slip/
+obj-$(CONFIG_SLIP) += slip/
 obj-$(CONFIG_SLHC) += slip/
 obj-$(CONFIG_NET_SB1000) += sb1000.o
-onj-$(CONFIG_SLIP) += slip/
+obj-$(CONFIG_SLIP) += slip/
 obj-$(CONFIG_SUNGEM_PHY) += sungem_phy.o
 obj-$(CONFIG_TR) += tokenring/
 obj-$(CONFIG_WAN) += wan/
