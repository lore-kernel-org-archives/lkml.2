Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0KGWlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:41:24 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:54602 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751727Ab0KGWlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:41:23 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX18TGitu5BYThoU663ASI2x6nUs4soA3KmJim4MKwd
	NlxkIoijTwtll+
Date: Sun, 7 Nov 2010 23:41:14 +0100
From: Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix spelling in drivers/misc/Kconfig
Message-ID: <20101107224114.GB19747@debian.debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello list.

This patch should be trivial and obvious.

Please CC me in replies.

Jonathan
---

--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=drivers

--- drivers/misc/Kconfig.orig	2010-11-07 22:56:37.000000000 +0100
+++ drivers/misc/Kconfig	2010-11-07 23:00:00.000000000 +0100
@@ -402,7 +402,7 @@
 	  DAC7512 16-bit digital-to-analog converter.
 
 	  This driver can also be built as a module. If so, the module
-	  will be calles ti_dac7512.
+	  will be called ti_dac7512.
 
 config VMWARE_BALLOON
 	tristate "VMware Balloon Driver"

--4bRzO86E/ozDv8r1--
