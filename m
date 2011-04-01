Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab1DAP4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:56:10 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52244 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755883Ab1DAP4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:56:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uVtf+T21+nFjjemNzT9bQWkz4pI3XPslYwfR9WazeoC1qRuENcLCDre+Ti8V6E9lL6t1gZmSEqEHjRexuipsdEgqRSECxSAJEIsTOZnPUrMFu1z7vkuQjl+ExP1LTLDd;
Date: Fri, 1 Apr 2011 08:56:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Andres Salomon <dilinger@queued.net>
Subject: [PATCH -mm] olpc: xo_1 needs delay.h
Message-Id: <20110401085605.dc8eb133.rdunlap@xenotime.net>
In-Reply-To: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org>
References: <201103312224.p2VMOA5g000983@imap1.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error, needs delay.h:

drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:168: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c |    1 +
 1 file changed, 1 insertion(+)

Can we get something in MAINTAINERS for OLPC, please?

--- mmotm-2011-0331-1448.orig/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ mmotm-2011-0331-1448/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -11,6 +11,7 @@
  * License as published by the Free Software Foundation.
  */
 #include <linux/cs5535.h>
+#include <linux/delay.h>
 #include <linux/gpio.h>
 #include <asm/olpc.h>
 
