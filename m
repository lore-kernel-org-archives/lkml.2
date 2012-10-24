Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388Ab2JXHH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:07:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41396 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933821Ab2JXHH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:07:27 -0400
From: Sebastien Guiriec <s-guiriec@ti.com>
To: Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v3 0/4] ARM: dts: Update OMAP5 with address space and interrupts
Date: Wed, 24 Oct 2012 09:07:10 +0200
Message-ID: <1351062434-22514-1-git-send-email-s-guiriec@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kernel 3.7 the DTS data are not overwriten by hwmod data we can add the address space
and interrupt line description inside dtsi file for OMAP5. This serie is updating the
current OMAP5 IP with missing entry.

It has been tested on OMAP5 with 3.7-audio-display feature tree.
- MMC is probing and functional
- TWL6041 probing (GPIO/I2C)
- booting (UART)

Update since v1:
- Add Ack and review
- Fix up commit messages.

Update since v2:
- Add interrupt-parent.

Sebastien Guiriec (4):
  ARM: dts: omap5: Update GPIO with address space and interrupts
  ARM: dts: omap5: Update I2C with address space and interrupts
  ARM: dts: omap5: Update UART with address space and interrupts
  ARM: dts: omap5: Update MMC with address space and interrupts

 arch/arm/boot/dts/omap5.dtsi |   80 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 76 insertions(+), 4 deletions(-)

-- 
1.7.10.4

