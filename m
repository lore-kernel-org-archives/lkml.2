Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3AHITz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:19:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60062 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab3AHITy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:19:54 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@ti.com>, <hs@denx.de>
Subject: [PATCH V2 0/3] ARM: davinci: da850: add pinctrl support
Date: Tue, 8 Jan 2013 13:50:17 +0530
Message-ID: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds:

* Add pinctrl-single for handling Padconf registers.
* Add NAND node to export NAND functionality on da850 EVM.
* Add NAND pinctrl node to do pin mux according to pinctrl-single driver.


This series applies on top of tag next-20130107 git tree
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

This series is tested on da850 EVM.

Changes since V1:

 -Remove the binding documentation as already documented as part of
  Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
 -Enable PINCTRL Kconfig for MACH_DA8XX_DT platform only.
 -Fix the pinctrl driver node unit-address.
 -Make separate patch for da8xx_omapl_defconfig changes.  

Kumar, Anil (3):
  ARM: davinci: da850: add pinctrl driver entries
  ARM: davinci: da8xx defconfig: enable pinctrl config option
  ARM: davinci: da850: add NAND driver entries

 arch/arm/boot/dts/da850-evm.dts        |   22 ++++++++++++++++++++++
 arch/arm/boot/dts/da850.dtsi           |   23 +++++++++++++++++++++++
 arch/arm/configs/da8xx_omapl_defconfig |    1 +
 arch/arm/mach-davinci/Kconfig          |    1 +
 4 files changed, 47 insertions(+), 0 deletions(-)

-- 
1.7.4.1

