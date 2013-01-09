Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301Ab3AIUof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:44:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:65270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934239Ab3AIUnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:47 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 11/14] ARM: tegra: tamonten: Add PCIe support
Date: Wed,  9 Jan 2013 21:43:11 +0100
Message-Id: <1357764194-12677-12-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:vDWldnwu9efcDwxj09427xUt5iNIRxkpgBbtvpPpPsb
 FQXSd1liXefndAkO5t5ywBQk1AKVpld09/h7y1EYHe5yyxcnGa
 JPo1zAc4kf6fk1MB1EwimvYIr6V8EtCApe/QgqhLe4YjTVtXHa
 FCr3ABImy45nEgCPR/akLUIkAAAADG7hKx9MWNkSw+TpOMtA4B
 AN1lTaOw0zuRQpk+xNPmqJuTze41O/f+KkxGsAvxljQZykIOks
 vnBOTadb6XMv8UEcyUMSi28RlXs52aKE1USU3eeHwWPXyqCYjm
 jadlv3jIdRNWSwM26JAddTaJOCSzcmdDl543ix34SZaqrp+RXC
 ib3xwl5hIfTmLLPILUOvNQ75bkdBxbDeA8HiHKp6IQBYCNBmcY
 FLbjsd6htiJYbaK53Dm9CyrHnfYm1jPLqwMr0TCZxzDicu2q3+
 QxlUm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/tegra20-tamonten.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 7edfb9a..0053c72 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -439,7 +439,7 @@
 					regulator-always-on;
 				};
 
-				ldo0 {
+				pci_clk_reg: ldo0 {
 					regulator-name = "vdd_ldo0,vddio_pex_clk";
 					regulator-min-microvolt = <3300000>;
 					regulator-max-microvolt = <3300000>;
-- 
1.8.1

