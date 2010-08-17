Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab0HQETv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:19:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38368
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938Ab0HQETu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:19:50 -0400
Date: Mon, 16 Aug 2010 21:20:07 -0700 (PDT)
Message-Id: <20100816.212007.193698272.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] arcmsr_hba: Missing slab.h include
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---

Linus please merge this directly, I think giving 2 weeks for a
maintainer to pick up a trivial build fix like this is sufficient.

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 95a895d..c8dc392 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -56,6 +56,7 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/timer.h>
+#include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <asm/dma.h>
