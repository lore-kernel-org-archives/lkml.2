Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1ESL50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:57:26 -0400
Received: from gate.krista.ru ([217.15.144.170]:25771 "EHLO gate.krista.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1ESL5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:57:25 -0400
X-Greylist: delayed 3901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 07:57:24 EDT
Date: Thu, 19 May 2011 15:54:59 +0400
From: samsonov@krista.ru
To: linux-kernel@vger.kernel.org
Subject: drivers/net/ppp_generic.c patch
Message-ID: <20110519155459.41dc9134@wks1198.krista.ru>
Organization: =?KOI8-R?B?7vDvIOvSydPUwQ==?=
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.8 [-37] (---) (gate.krista.ru)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- ./linux-2.6.33.4.orig/drivers/net/ppp_generic.c	2010-05-13 02:04:27.000000000 +0400
+++ ./linux-2.6.33.4/drivers/net/ppp_generic.c	2011-05-19 15:46:43.836422678 +0400
@@ -363,11 +363,6 @@
 static int ppp_open(struct inode *inode, struct file *file)
 {
 	cycle_kernel_lock();
-	/*
-	 * This could (should?) be enforced by the permissions on /dev/ppp.
-	 */
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
 	return 0;
 }
