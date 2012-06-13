Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2FMMyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:54:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52319 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753320Ab2FMMyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:54:23 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX1+c4upRt02cNlmmnGMkgR2i2AqyxbGAqz4dJmFZlb
	oXR27xN/NpgGrB
From: "Jan-Simon =?iso-8859-1?q?M=F6ller?=" <dl9pf@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: KDB and usb or dbgp - status ?
Date: Wed, 13 Jun 2012 14:54:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc2-ftrace1-00012-gb0a4c6f; KDE/4.6.0; x86_64; ; )
Cc: Jason Wessel <jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206131454.15218.dl9pf@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

I sat down an tried to figure out how to use KDB (also through dbgp) with 
latest mainline. It turned out to be a no-go unless I have hardware with PS/2 
for keyboard. 
I wonder whats the status regarding USB keyboards and the USB EHCI debugport.

Am I right or is USB keyboard support not available in KDB/mainline ?

How well does the EHCI debugport work and what steps are needed to reproduce ?
I tried it with g_dbgp on a beagleboard as "host" for the debugging session.

Whats the status ?

Best,
Jan-Simon
