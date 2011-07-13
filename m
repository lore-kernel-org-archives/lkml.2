Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1GMNq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:46:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45542 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1GMNq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:46:26 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] input: xilinx_ps2: Add missing of_address.h header
Date: Wed, 13 Jul 2011 15:46:21 +0200
Message-Id: <1310564781-5979-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing header.

Error log:
CC      drivers/input/serio/xilinx_ps2.o
drivers/input/serio/xilinx_ps2.c: In function 'xps2_of_probe':
drivers/input/serio/xilinx_ps2.c:249: error: implicit declaration of function 'of_address_to_resource'

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/input/serio/xilinx_ps2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
index 80baa53..d64c5a4 100644
--- a/drivers/input/serio/xilinx_ps2.c
+++ b/drivers/input/serio/xilinx_ps2.c
@@ -23,7 +23,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/io.h>
-
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 
-- 
1.5.5.6

