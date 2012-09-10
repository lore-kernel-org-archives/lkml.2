Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2IJToN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:44:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47150 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab2IJToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:44:08 -0400
From: Matt Porter <mporter@ti.com>
To: Linux OMAP List <linux-omap@vger.kernel.org>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, AnilKumar <anilkumar@ti.com>
Subject: [PATCH v2 0/2] ARM: dts: AM33xx: Correct gpio labels to match docs
Date: Mon, 10 Sep 2012 15:45:10 -0400
Message-Id: <1347306312-31533-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
	- Series now applies on top of Anil's AM33XX DTS series
 
This series applies on top of the for_3.7/dts/ branch and Anil's
"[v7,2/3] arm/dts: AM33XX: Configure pinmuxs for user leds control on Bone"
patch that is part of the overall series adding led and pinctrl DTS data
for AM33xx.

It is intended to correct the current labeling of gpios in the DTS before
too many more drivers are submitted for AM33xx that have gpios not matching
the docs.

Matt Porter (2):
  ARM: dts: AM33XX: fix gpio node numbering to match hardware
  ARM: dts: AM33XX: adjust leds to use the corrected gpio label

 arch/arm/boot/dts/am335x-bone.dts |    8 ++++----
 arch/arm/boot/dts/am33xx.dtsi     |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.7.9.5

