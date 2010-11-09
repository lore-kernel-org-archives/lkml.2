Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0KIWUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:20:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56328 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754158Ab0KIWUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:20:30 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX183M+gA+7M3J6FBePbJ9SbimEXcXx0hyoS1E8G5fT
	rXR/CapZ/ERguc
Date: Tue, 9 Nov 2010 23:20:26 +0100
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] spelling fix in drivers/misc/Kconfig
Message-ID: <20101109222026.GA1293@debian.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Neuschäfer
---
Kernel version: 2.6.37-rc1

 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6/drivers/misc/Kconfig	2010-11-07 22:56:37.000000000 +0100
+++ linux-hacking/drivers/misc/Kconfig	2010-11-08 21:10:13.000000000 +0100
@@ -402,7 +402,7 @@
 	  DAC7512 16-bit digital-to-analog converter.
 
 	  This driver can also be built as a module. If so, the module
-	  will be calles ti_dac7512.
+	  will be called ti_dac7512.
 
 config VMWARE_BALLOON
 	tristate "VMware Balloon Driver"
