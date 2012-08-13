Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab2HMKER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:04:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53215 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2HMKEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:04:15 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Sourav Poddar <sourav.poddar@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCHv2 0/4] Add device tree data for omap5
Date: Mon, 13 Aug 2012 15:35:09 +0530
Message-ID: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
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

