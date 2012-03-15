Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998Ab2COSfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:35:16 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54006 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669Ab2COSfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:35:12 -0400
From: Aneesh V <aneesh@ti.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Aneesh V <aneesh@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 0/4] dt: device tree support for TI EMIF driver
Date: Fri, 16 Mar 2012 00:04:03 +0530
Message-Id: <1331836447-7584-1-git-send-email-aneesh@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds device tree support for TI EMIF SDRAM controller
driver. For this, a binding has been added for representing AC timing
parameters and other details of LPDDR2 memories.

This series depends v2 of my series for adding EMIF driver [1]

[1] http://marc.info/?l=linux-omap&m=133183554007498&w=2

Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

Aneesh V (4):
  dt: device tree bindings for LPDDR2 memories
  dt: emif: device tree bindings for TI's EMIF sdram controller
  arm: dts: EMIF and LPDDR2 device tree data for OMAP4 boards
  misc: emif: add device tree support to emif driver

 .../devicetree/bindings/lpddr2/lpddr2-timings.txt  |   52 ++++
 .../devicetree/bindings/lpddr2/lpddr2.txt          |  102 +++++++
 .../bindings/memory-controllers/ti/emif.txt        |   55 ++++
 arch/arm/boot/dts/elpida_ecb240abacn.dtsi          |   67 +++++
 arch/arm/boot/dts/omap4-panda.dts                  |   13 +
 arch/arm/boot/dts/omap4-sdp.dts                    |   13 +
 arch/arm/boot/dts/omap4.dtsi                       |   18 ++
 drivers/misc/emif.c                                |  285 +++++++++++++++++++-
 8 files changed, 604 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/lpddr2/lpddr2-timings.txt
 create mode 100644 Documentation/devicetree/bindings/lpddr2/lpddr2.txt
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti/emif.txt
 create mode 100644 arch/arm/boot/dts/elpida_ecb240abacn.dtsi

