Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab0KDR3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:29:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56151 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab0KDR3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:29:21 -0400
Date: Thu, 4 Nov 2010 10:28:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, akpm <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] leds-net5501: taints kernel, add license
Message-Id: <20101104102800.6b1cc210.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add MODULE_LICENSE() that matches file comments so that kernel
is not tainted.

	leds_net5501: module license 'unspecified' taints kernel.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/leds/leds-net5501.c |    2 ++
 1 file changed, 2 insertions(+)

Alessandro, why does this module not have a module_exit() function?
I.e., why can it not be unloaded?


--- lnx-2637-rc1.orig/drivers/leds/leds-net5501.c
+++ lnx-2637-rc1/drivers/leds/leds-net5501.c
@@ -92,3 +92,5 @@ unmap:
 }
 
 arch_initcall(soekris_init);
+
+MODULE_LICENSE("GPL");
