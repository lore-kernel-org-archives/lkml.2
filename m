Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab0HXEYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:24:16 -0400
Received: from kroah.org ([198.145.64.141]:56415 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0HXEYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 00:24:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/6] serial: print early console device address in hex
Date: Mon, 23 Aug 2010 21:24:01 -0700
Message-Id: <1282623846-17050-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100824040508.GC16749@kroah.com>
References: <20100824040508.GC16749@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luck, Tony <tony.luck@intel.com>

Device addresses are usually printed in hex.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250_early.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index b745792..eaafb98 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -203,13 +203,13 @@ static int __init parse_options(struct early_serial8250_device *device,
 
 	if (mmio || mmio32)
 		printk(KERN_INFO
-		       "Early serial console at MMIO%s 0x%llu (options '%s')\n",
+		       "Early serial console at MMIO%s 0x%llx (options '%s')\n",
 			mmio32 ? "32" : "",
 			(unsigned long long)port->mapbase,
 			device->options);
 	else
 		printk(KERN_INFO
-		      "Early serial console at I/O port 0x%lu (options '%s')\n",
+		      "Early serial console at I/O port 0x%lx (options '%s')\n",
 			port->iobase,
 			device->options);
 
-- 
1.7.2

