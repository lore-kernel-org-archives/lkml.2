Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1I2DyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 23:54:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52534 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1I2DyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 23:54:11 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/2] GIC OF bindings
Date: Wed, 28 Sep 2011 22:53:54 -0500
Message-Id: <1317268436-1613-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

With recent patches for VIC device tree support and GIC MULTI_IRQ support,
it is evident that the irq domain support should be moved into the core GIC
code and not be dependent on the DT initialization. So I've split things up
into 2 patches separating irq_domain and device-tree code.

This should only change the internals of the GIC code. The binding is
unchanged from the previous version. Yeah!

The full series is available here. This includes Russell's devel-stable and
for-next branches and Nico's vmalloc branch.

git://git.jdl.com/software/linux-3.0.git gic

Rob

Rob Herring (2):
  ARM: gic: add irq_domain support
  ARM: gic: add OF based initialization

 Documentation/devicetree/bindings/arm/gic.txt |   55 ++++++++++
 arch/arm/common/Kconfig                       |    1 +
 arch/arm/common/gic.c                         |  144 +++++++++++++++++++------
 arch/arm/include/asm/hardware/gic.h           |    4 +
 4 files changed, 171 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/gic.txt

-- 
1.7.5.4

