Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab2HGSm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:42:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54938 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117Ab2HGSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:42:56 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <rmk@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/7] resources: Document IORESOURCE_IO
Date: Tue,  7 Aug 2012 19:42:46 +0100
Message-Id: <1344364969-32489-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Help clarify that this is specifically for PCI/ISA I/O ports and not for
any other similar thing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/ioport.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index bfee885..85ac9b9b 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -29,7 +29,7 @@ struct resource {
 #define IORESOURCE_BITS		0x000000ff	/* Bus-specific bits */
 
 #define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
-#define IORESOURCE_IO		0x00000100
+#define IORESOURCE_IO		0x00000100	/* PCI/ISA I/O ports */
 #define IORESOURCE_MEM		0x00000200
 #define IORESOURCE_REG		0x00000300	/* Register offsets */
 #define IORESOURCE_IRQ		0x00000400
-- 
1.7.10.4

