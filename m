Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2CEK6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:58:13 -0500
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:52792 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756578Ab2CEK6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:58:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhdang@apm.com designates 10.68.242.135 as permitted sender) smtp.mail=dhdang@apm.com
MIME-Version: 1.0
From: Duc Dang <dhdang@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
        Josh Boyer <jwboyer@gmail.com>, Stefan Roese <sr@denx.de>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Duc Dang <dhdang@apm.com>
Subject: [PATCH v3 1/2] powerpc/44x: Add new compatible value for EMAC node of APM821XX dts file.
Date: Mon,  5 Mar 2012 17:57:42 +0700
Message-Id: <1330945062-15760-1-git-send-email-dhdang@apm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330920224-3006-1-git-send-email-dhdang@apm.com>
References: <1330920224-3006-1-git-send-email-dhdang@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This compatible value will be used to distinguish some special features of APM821XX EMAC: no half duplex mode support, configuring jumbo frame.

Signed-off-by: Duc Dang <dhdang@apm.com>
---
v3:
 No change since v1/v2 patch sets. Added for completeness.

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

