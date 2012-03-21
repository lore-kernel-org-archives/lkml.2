Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab2CUCWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 22:22:37 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:35859 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752835Ab2CUCWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 22:22:36 -0400
From: Mai La <mla@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Mai La <mla@apm.com>
Subject: [PATCH] powerpc/44x: Support CPM for Maui APM821xxx SoC and Bluestone board
Date: Wed, 21 Mar 2012 09:21:12 +0700
Message-Id: <1332296472-24734-1-git-send-email-mla@apm.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch:
- Add CPM node for Maui APM821xxx SoC and Bluestone board in DTS

Signed-off-by: Mai La <mla@apm.com>
---
 arch/powerpc/boot/dts/bluestone.dts |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/boot/dts/bluestone.dts b/arch/powerpc/boot/dts/bluestone.dts
index 2a56a0d..15a9516 100644
--- a/arch/powerpc/boot/dts/bluestone.dts
+++ b/arch/powerpc/boot/dts/bluestone.dts
@@ -117,6 +117,15 @@
 		dcr-reg = <0x00c 0x002>;
 	};
 
+	CPM0: cpm {
+		compatible = "ibm, cpm-apm821xx", "ibm,cpm";
+		cell-index = <0>;
+		dcr-reg = <0x160 0x003>;
+		er-offset = <0>;
+		idle-doze = <0x02000000>;
+		standby = <0x302570F0>;
+	};
+
 	plb {
 		compatible = "ibm,plb4";
 		#address-cells = <2>;
-- 
1.7.3.4

