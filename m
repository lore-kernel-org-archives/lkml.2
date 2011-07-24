Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1GXD1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 23:27:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63874 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1GXD1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 23:27:01 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] ARM:mach-dove:remove the dup include serial_8250.h
Date: Sun, 24 Jul 2011 11:24:32 +0800
Message-Id: <1311477872-4329-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

linux/serial_8250.h has been included for twice.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 arch/arm/mach-dove/common.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 5ed51b8..b6c3d6b 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -17,7 +17,6 @@
 #include <linux/clk.h>
 #include <linux/mbus.h>
 #include <linux/ata_platform.h>
-#include <linux/serial_8250.h>
 #include <linux/gpio.h>
 #include <asm/page.h>
 #include <asm/setup.h>
-- 
1.7.4.1

