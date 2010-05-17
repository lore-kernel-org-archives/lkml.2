Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0EQR4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:56:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46112 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0EQR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:56:48 -0400
Date: Mon, 17 May 2010 10:54:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] vga: fix kconfig text typos
Message-Id: <20100517105404.449486a8.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BF18338.0033:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos in vga/Kconfig file
and use GPU (upper case) consistently.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	David Airlie <airlied@linux.ie>
Cc:	dri-devel@lists.freedesktop.org
---
 drivers/gpu/vga/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lnx-2634.orig/drivers/gpu/vga/Kconfig
+++ lnx-2634/drivers/gpu/vga/Kconfig
@@ -18,12 +18,12 @@ config VGA_ARB_MAX_GPUS
 	  multiple GPUS.  The overhead for each GPU is very small.
 
 config VGA_SWITCHEROO
-	bool "Laptop Hybrid Grapics - GPU switching support"
+	bool "Laptop Hybrid Graphics - GPU switching support"
 	depends on X86
 	depends on ACPI
 	help
-	  Many laptops released in 2008/9/10 have two gpus with a multiplxer
+	  Many laptops released in 2008/9/10 have two GPUs with a multiplexer
 	  to switch between them. This adds support for dynamic switching when
           X isn't running and delayed switching until the next logoff. This
-	  features is called hybrid graphics, ATI PowerXpress, and Nvidia
+	  feature is called hybrid graphics, ATI PowerXpress, and Nvidia
 	  HybridPower.
