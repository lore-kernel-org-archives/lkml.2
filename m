Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab1CPAJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:09:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16699 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab1CPAJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:09:29 -0400
Date: Tue, 15 Mar 2011 17:09:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>
Subject: [PATCH -next] usb: fix ips1760-hcd printk format warning
Message-Id: <20110315170910.9b6f1c58.randy.dunlap@oracle.com>
In-Reply-To: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
References: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D7FFFAC.00AC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format build warning and grammar typo on same line.

drivers/usb/host/isp1760-hcd.c:300: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/host/isp1760-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110315.orig/drivers/usb/host/isp1760-hcd.c
+++ linux-next-20110315/drivers/usb/host/isp1760-hcd.c
@@ -295,7 +295,7 @@ static void alloc_mem(struct usb_hcd *hc
 	}
 
 	dev_err(hcd->self.controller,
-				"%s: Can not allocate %lu bytes of memory\n"
+				"%s: Cannot allocate %zu bytes of memory\n"
 				"Current memory map:\n",
 				__func__, qtd->length);
 	for (i = 0; i < BLOCKS; i++) {
