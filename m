Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2GaGq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:46:59 -0400
Received: from londo.lunn.ch ([80.238.139.98]:42547 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab2GaGq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:46:58 -0400
Date: Tue, 31 Jul 2012 08:46:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Cc: linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        David Brown <davidb@codeaurora.org>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 1/1] ARM: dove: DT support for sdhci-dove
Message-ID: <20120731064651.GA13624@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+++ b/Documentation/devicetree/bindings/mmc/sdhci-dove.txt
@@ -0,0 +1,12 @@
+* Marvell sdhci-dove controller
+
+Required properties:
+- compatible: Should be "marvell,dove-sdhci".
+
+Example:
+
+sdio0: sdio@92000 {
+       compatible = "marvell,dove-sdhci";
+       reg = <0x92000 0x100>;
+       interrupts = <35>, <37>;


Hi Sebastian

Since there are two interrupts here, maybe it would be good to
document what each one is?

	 Thanks
		Andrew
