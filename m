Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2DREdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:33:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60385 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2DREdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:33:32 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 01/12] drivers: block: mtip32xx: mtip32xx.h: Remove unnneeded include of version.h
Date: Wed, 18 Apr 2012 01:30:01 -0300
Message-Id: <1334723412-5034-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of "make versioncheck" points that the include of version.h
in the drivers/block/mtip32xx/mtip32xx.h is unneeded. If we take a look
at the file, we can agree to remove it.

c: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/block/mtip32xx/mtip32xx.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 4ef5833..6f0b60f 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -26,7 +26,6 @@
 #include <linux/ata.h>
 #include <linux/interrupt.h>
 #include <linux/genhd.h>
-#include <linux/version.h>
 
 /* Offset of Subsystem Device ID in pci confoguration space */
 #define PCI_SUBSYSTEM_DEVICEID	0x2E
-- 
1.7.7.6

