Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab0DIUbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:31:51 -0400
Received: from mtumx-2.merit.edu ([198.108.1.20]:62859 "EHLO mail.mtu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755576Ab0DIUbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:31:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEcpv0uN208i/2dsb2JhbADPCIhchQkEjj4
X-IronPort-AV: E=Sophos;i="4.52,179,1270440000"; 
   d="scan'208";a="282120518"
Message-ID: <4BBF8C76.7010000@mtu.edu>
Date: Fri, 09 Apr 2010 16:22:14 -0400
From: Jakob Penzien <jwpenzie@mtu.edu>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: gregkh@suse.de, wfp5p@virginia.edu, bart@cs.pdx.edu,
       linux@dominikbrodowski.net, keil@b1-systems.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: ni_labpc_cs.c 2
References: <4B8DF681.4050903@mtu.edu>
In-Reply-To: <4B8DF681.4050903@mtu.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jakob Penzien <jwpenzie@mtu.edu>
Date: Wed, 3 Mar 2010 00:31:24 -0500
Subject: [PATCH 2/2] Staging: Comedi: fix 80 character and KERN
coding style issue in ni_labpc_cs.c
 This is a patch to the ni_labpc_cs.c file that fixes up the 80
character and KERN
 warning found by the checkpoint.pl tool. Changed the spaceing
between KERN and ".
 Signed-off-by: Jakob Penzien <Supermine290@gmail.com>

---
 drivers/staging/comedi/drivers/ni_labpc_cs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c
b/drivers/staging/comedi/drivers/ni_labpc_cs.c
index 0b963bb..07d7bf9 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
@@ -1,7 +1,8 @@
 /*
     comedi/drivers/ni_labpc_cs.c
     Driver for National Instruments daqcard-1200 boards
-    Copyright (C) 2001, 2002, 2003 Frank Mori Hess
<fmhess@users.sourceforge.net>
+    Copyright (C) 2001, 2002, 2003 Frank Mori Hess
+    <fmhess@users.sourceforge.net>

     PCMCIA crap is adapted from dummy_cs.c 1.31 2001/08/24 12:13:13
     from the pcmcia package.
@@ -146,7 +147,7 @@ static int labpc_attach(struct comedi_device
*dev, struct comedi_devconfig *it)
 		irq = link->irq.AssignedIRQ;
 		break;
 	default:
-		printk("bug! couldn't determine board type\n");
+		printk(KERN_ERR "bug! couldn't determine board type\n");
 		return -EINVAL;
 		break;
 	}

