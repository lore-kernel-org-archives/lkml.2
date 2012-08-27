Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab2H0McY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 08:32:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60158 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab2H0McW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 08:32:22 -0400
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/2] arm/dts: AM33XX: Add reg and interrupt property for all nodes
Date: Mon, 27 Aug 2012 18:01:52 +0530
Message-ID: <1346070714-6122-1-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is trivial patch-series and should be considered as
preparation for the future where we supposed to get rid of
hwmod dependency.

1/2: Converts all hex numbers to lowercase, fixing inconsistency
2/2: Add reg and interrupt property  to all device/module nodes inside
     DTS files. 

Although currently hwmod overwrites resources, I have validated this
patch series by changing the omap_device layer to respect DT resources
and boot Tested on BeagleBone platform.
I will be submitting the changes for omap_device layer as well, still
needs to fix on certain things.

Vaibhav Hiremath (2):
  arm/dts: AM33XX: Convert all hex numbers to lower-case
  arm/dts: AM33XX: Specify reg and interrupt property for all nodes

 arch/arm/boot/dts/am335x-bone.dts |    2 +-
 arch/arm/boot/dts/am335x-evm.dts  |    2 +-
 arch/arm/boot/dts/am33xx.dtsi     |   62 +++++++++++++++++++++++++++++++------
 3 files changed, 54 insertions(+), 12 deletions(-)

