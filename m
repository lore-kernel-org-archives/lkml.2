Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1CJWgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:36:43 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:55043 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1CJWgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:36:42 -0500
Date: Thu, 10 Mar 2011 17:36:37 -0500
From: j223yang@asset.uwaterloo.ca
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] ariadne: remove redundant NULL check
Message-ID: <20110310223636.GA11399@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply remove redundant 'dev' NULL check.
Source code uses spaces instead of TAB, except 'printk' and 'return' lines.


Signed-off-by: Jinqiu Yang <crindy646@gmail.com>
---
 ariadne.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/ariadne.c	2011-03-10 11:20:14.076039323 -0500
+++ b/drivers/net/ariadne.c	2011-03-10 11:21:59.111164537 -0500
@@ -425,11 +425,6 @@ static irqreturn_t ariadne_interrupt(int
     int csr0, boguscnt;
     int handled = 0;
 
-    if (dev == NULL) {
-	printk(KERN_WARNING "ariadne_interrupt(): irq for unknown device.\n");
-	return IRQ_NONE;
-    }
-
     lance->RAP = CSR0;			/* PCnet-ISA Controller Status */
 
     if (!(lance->RDP & INTR))		/* Check if any interrupt has been */
