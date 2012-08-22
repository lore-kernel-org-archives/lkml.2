Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2HVNuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:50:03 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:51681 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666Ab2HVNuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:50:01 -0400
From: Roland Stigge <stigge@antcom.de>
To: linus.walleij@linaro.org, aletes.xgr@gmail.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v6 3/3] DT bindings documentation: "num-cs" property for SPI controllers
Date: Wed, 22 Aug 2012 15:49:19 +0200
Message-Id: <1345643359-16584-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345643359-16584-1-git-send-email-stigge@antcom.de>
References: <1345643359-16584-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several SPI controller drivers have defined differently named properties for
the number of chip selects.  Now adding "num-cs" as a reference name for new
bindings.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 Documentation/devicetree/bindings/spi/spi-bus.txt |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.orig/Documentation/devicetree/bindings/spi/spi-bus.txt
+++ linux-2.6/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -21,6 +21,9 @@ assumption that board specific platform
 chip selects.  Individual drivers can define additional properties to
 support describing the chip select layout.
 
+Optional property:
+- num-cs : total number of chipselects
+
 SPI slave nodes must be children of the SPI master node and can
 contain the following properties.
 - reg             - (required) chip select address of device.
