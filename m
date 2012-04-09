Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2DIHVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:21:43 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44028 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754010Ab2DIHVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:21:39 -0400
From: Tanmay Inamdar <tinamdar@apm.com>
To: benh@kernel.crashing.org, jwboyer@gmail.com, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Tanmay Inamdar <tinamdar@apm.com>
Subject: [V2 4/5] powerpc: config: 40x: Add 16650 UART support in klondike defconfig
Date: Mon,  9 Apr 2012 12:50:51 +0530
Message-Id: <1333956052-25319-4-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
In-Reply-To: <1333956052-25319-3-git-send-email-tinamdar@apm.com>
References: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
 <1333956052-25319-2-git-send-email-tinamdar@apm.com>
 <1333956052-25319-3-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 16650 UART support in klondike_defconfig for APM8018X SOC

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
:100644 100644 c0d228d... c35c345... M	arch/powerpc/configs/40x/klondike_defconfig
 arch/powerpc/configs/40x/klondike_defconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/configs/40x/klondike_defconfig b/arch/powerpc/configs/40x/klondike_defconfig
index c0d228d..c35c345 100644
--- a/arch/powerpc/configs/40x/klondike_defconfig
+++ b/arch/powerpc/configs/40x/klondike_defconfig
@@ -30,6 +30,12 @@ CONFIG_SCSI_SAS_ATTRS=y
 # CONFIG_UNIX98_PTYS is not set
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=2
+CONFIG_SERIAL_8250_RUNTIME_UARTS=2
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_OF_PLATFORM=y
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
 # CONFIG_USB_SUPPORT is not set
-- 
1.6.1.rc3

