Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2BQIG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:06:56 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:43858 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751730Ab2BQIGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:06:55 -0500
MIME-Version: 1.0
From: Duc Dang <dhdang@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Duc Dang <dhdang@apm.com>
Subject: [PATCH 1/2] powerpc/44x: Add new compatible value for EMAC node of APM821XX dts file.
Date: Fri, 17 Feb 2012 15:06:17 +0700
Message-Id: <1329465977-15924-1-git-send-email-dhdang@apm.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This compatible value will be used to distinguish some special
features of APM821XX EMAC: no half duplex mode support, configuring 
jumbo frame.

Signed-off-by: Duc Dang <dhdang@apm.com>
---
 arch/powerpc/boot/dts/bluestone.dts |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/boot/dts/bluestone.dts b/arch/powerpc/boot/dts/bluestone.dts
index 2a56a0d..74876f7 100644
--- a/arch/powerpc/boot/dts/bluestone.dts
+++ b/arch/powerpc/boot/dts/bluestone.dts
@@ -222,7 +222,7 @@
 
 			EMAC0: ethernet@ef600c00 {
 				device_type = "network";
-				compatible = "ibm,emac4sync";
+				compatible = "ibm,emac-apm821xx", "ibm,emac4sync";
 				interrupt-parent = <&EMAC0>;
 				interrupts = <0x0 0x1>;
 				#interrupt-cells = <1>;
-- 
1.7.5.4

