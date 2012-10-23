Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2JWIh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:37:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55587 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab2JWIhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:37:23 -0400
From: Sebastien Guiriec <s-guiriec@ti.com>
To: Sebastien Guiriec <s-guiriec@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 0/4] ARM: dts: Update OMAP5 with address space and interrupts
Date: Tue, 23 Oct 2012 10:37:08 +0200
Message-ID: <1350981432-6750-1-git-send-email-s-guiriec@ti.com>
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

Sebastien Guiriec (4):
  ARM: dts: omap5: Update GPIO with address space and interrupts
  ARM: dts: omap5: Update I2C with address space and interrupts
  ARM: dts: omap5: Update UART with address space and interrupts
  ARM: dts: omap5: Update MMC with address space and interrupts

 arch/arm/boot/dts/omap5.dtsi |   56 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

-- 
1.7.10.4

