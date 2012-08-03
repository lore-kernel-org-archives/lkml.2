Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2HCMiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:38:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35084 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2HCMiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:38:08 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Sourav Poddar <sourav.poddar@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 0/4] Add device tree data for omap5  
Date: Fri, 3 Aug 2012 18:08:02 +0530
Message-ID: <1343997486-710-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series add i2c support for omap5.
As well as enable I2C based devices like pressure and temperature
through device tree. Also add onchip keypad dts data.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>

Sourav Poddar (4):
  arm/dts: omap5-evm: Add I2C support
  arm/dts: omap5-evm: Add tmp102 sensor support
  arm/dts: omap5-evm: Add keypad data
  arm/dts: omap5-evm: Add bmp085 sensor support

 arch/arm/boot/dts/omap5-evm.dts |   30 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap5.dtsi    |   40 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

