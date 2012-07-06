Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2GFOIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:08:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab2GFOIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:08:42 -0400
Subject: [PATCH] CONFIG_CC_STACKPROTECTOR is no longer experimental
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Fri, 06 Jul 2012 16:08:25 +0200
Message-ID: <1341583705.4655.18.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature has been around for over 5 years now, so I presume it is
no longer considered experimental.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
Or is there any reason to still consider this an experimental feature?

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.5-rc5.orig/arch/x86/Kconfig	2012-06-05 16:22:58.000000000 +0200
+++ linux-3.5-rc5/arch/x86/Kconfig	2012-07-06 15:32:55.660276577 +0200
@@ -1525,7 +1525,7 @@ config SECCOMP
 	  If unsure, say Y. Only embedded should say N here.
 
 config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
+	bool "Enable -fstack-protector buffer overflow detection"
 	---help---
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on

-- 
Jean Delvare
Suse L3

