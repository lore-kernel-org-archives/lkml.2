Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0KLSlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:41:09 -0500
Received: from mout.perfora.net ([74.208.4.195]:50822 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0KLSlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:41:08 -0500
Message-ID: <4CDD8A42.6010401@nctritech.com>
Date: Fri, 12 Nov 2010 13:41:06 -0500
From: Jody Bruchon <jody@nctritech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/cifs/Kconfig: CIFS depends on CRYPTO_HMAC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:QoCnvKE51JCSoQh/CW7dF2tn3Q5zXYFlTR2Q2Sltqdz
 +BT3r4iWpSW+9M4oEGriVEOlYE43vmnoZ6ODDqx1jqWMYlTKtc
 msdZFuPyb60XCwW3Oq6JTsWuacxHHEmdFMfDaCtQtWP+ADPqPa
 JS+DkdFwG0+liHXHlKvb1OApQI0piZcwORSwsfCBSIdpIjEtpB
 DK7Vsm3pyfnCMc7n9ebnIDnnQLE+XDS3oZcHZdS7Yc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-2.6.37-rc1: I compiled a kernel with CIFS which subsequently 
failed with an error indicating it couldn't initialize crypto module 
"hmacmd5".  CONFIG_CRYPTO_HMAC=y fixed the problem.

This patch makes CIFS depend on CRYPTO_HMAC in kconfig.

Signed-off-by: Jody Bruchon <jody@nctritech.com>
---

diff -Naur linux-2.6.37-rc1/fs/cifs/Kconfig b/fs/cifs/Kconfig
--- linux-2.6.37-rc1/fs/cifs/Kconfig    2010-11-12 13:22:31.742999981 -0500
+++ b/fs/cifs/Kconfig    2010-11-12 13:22:27.528998658 -0500
@@ -4,6 +4,7 @@
      select NLS
      select CRYPTO
      select CRYPTO_MD5
+    select CRYPTO_HMAC
      select CRYPTO_ARC4
      help
        This is the client VFS module for the Common Internet File System


