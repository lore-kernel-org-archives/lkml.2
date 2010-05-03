Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab0ECPsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:48:12 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42446 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab0ECPsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:48:09 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Alexandre Bounine <alexandre.bounine@idt.com>,
       Matt Porter <mporter@kernel.crashing.org>,
       Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
       Thomas Moll <thomas.moll@sysgo.com>
Subject: [PATCH -mm 1/5] RapidIO: Fixed typos and minor edits
Date: Mon,  3 May 2010 11:45:54 -0400
Message-Id: <1272901558-9292-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
References: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Thomas Moll <thomas.moll@sysgo.com>
---
 drivers/rapidio/rio.c            |    1 -
 drivers/rapidio/switches/Kconfig |    8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 8fa732e..777e099 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -445,7 +445,6 @@ static struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from)
 	struct list_head *n;
 	struct rio_dev *rdev;
 
-	WARN_ON(in_interrupt());
 	spin_lock(&rio_global_list_lock);
 	n = from ? from->global_list.next : rio_devices.next;
 
diff --git a/drivers/rapidio/switches/Kconfig b/drivers/rapidio/switches/Kconfig
index 6969f39..2b4e9b2 100644
--- a/drivers/rapidio/switches/Kconfig
+++ b/drivers/rapidio/switches/Kconfig
@@ -5,24 +5,24 @@ config RAPIDIO_TSI57X
 	bool "IDT Tsi57x SRIO switches support"
 	depends on RAPIDIO
 	---help---
-	  Includes support for ITD Tsi57x family of serial RapidIO switches.
+	  Includes support for IDT Tsi57x family of serial RapidIO switches.
 
 config RAPIDIO_CPS_XX
 	bool "IDT CPS-xx SRIO switches support"
 	depends on RAPIDIO
 	---help---
-	  Includes support for ITD CPS-16/12/10/8 serial RapidIO switches.
+	  Includes support for IDT CPS-16/12/10/8 serial RapidIO switches.
 
 config RAPIDIO_TSI568
 	bool "Tsi568 SRIO switch support"
 	depends on RAPIDIO
 	default n
 	---help---
-	  Includes support for ITD Tsi568 serial RapidIO switch.
+	  Includes support for IDT Tsi568 serial RapidIO switch.
 
 config RAPIDIO_TSI500
 	bool "Tsi500 Parallel RapidIO switch support"
 	depends on RAPIDIO
 	default n
 	---help---
-	  Includes support for ITD Tsi500 parallel RapidIO switch.
+	  Includes support for IDT Tsi500 parallel RapidIO switch.
-- 
1.7.0.5

