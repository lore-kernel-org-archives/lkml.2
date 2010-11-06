Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0KFTDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:03:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58097 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0KFTDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aUApMGQ6OfUnnChOOum0PuayCjhyXASbB5c3MnTKN7BnvRvSBC9tdx7tzuQpDNU+yF
         TJcWQB4o5+3wy7rn3cQStnX5nrrzAEOJgWczbNPC0ONVmeK7W2blVCeko0kO7oNEFZw7
         e3E6Sw2v7Hlq10OM5GKhfXTBgBFuoQz23En5w=
From: Tracey Dent <tdent48227@gmail.com>
To: dan.j.williams@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, agust@denx.de, linus.walleij@stericsson.com,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 2/2] Drivers: dma: ioat: Makeile: Cleaned up Makefile
Date: Sat,  6 Nov 2010 15:03:37 -0400
Message-Id: <1289070217-2513-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1289070217-2513-1-git-send-email-tdent48227@gmail.com>
References: <1289070217-2513-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/dma/ioat/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/Makefile b/drivers/dma/ioat/Makefile
index 8997d3f..0ff7270 100644
--- a/drivers/dma/ioat/Makefile
+++ b/drivers/dma/ioat/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INTEL_IOATDMA) += ioatdma.o
-ioatdma-objs := pci.o dma.o dma_v2.o dma_v3.o dca.o
+ioatdma-y := pci.o dma.o dma_v2.o dma_v3.o dca.o
-- 
1.7.3.1.104.gc752e

