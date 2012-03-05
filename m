Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2CEEAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 23:00:51 -0500
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:54779 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756100Ab2CEEAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 23:00:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhdang@apm.com designates 10.68.73.234 as permitted sender) smtp.mail=dhdang@apm.com
MIME-Version: 1.0
From: Duc Dang <dhdang@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
        Josh Boyer <jwboyer@gmail.com>
Cc: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Duc Dang <dhdang@apm.com>
Subject: [PATCH v2 1/2] powerpc/44x: Add new compatible value for EMAC node of APM821XX dts file.
Date: Mon,  5 Mar 2012 11:00:19 +0700
Message-Id: <1330920019-2957-1-git-send-email-dhdang@apm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329466058-15969-1-git-send-email-dhdang@apm.com>
References: <1329466058-15969-1-git-send-email-dhdang@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This compatible value will be used to distinguish some special features of APM821XX EMAC: no half duplex mode support, configuring jumbo frame.

Signed-off-by: Duc Dang <dhdang@apm.com>
---
v2:
 No change since v1 patch set. Added for completeness.

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

