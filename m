Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2KSJkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:40:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64113 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2KSJkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:40:06 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Dove pinctrl fixes and DT enabling
Date: Mon, 19 Nov 2012 10:39:52 +0100
Message-Id: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With other Orion SoCs moving to DT enabled pinctrl and gpio drivers,
now also move Dove to them. This patch set first fixes some issues
introduced during the first release of dove pinctrl and now. Then it
moves Dove to DT pinctrl and gpio and enables a gpio led pinhog for
CuBox.

This patch relies on a patch set for mvebu pinctrl taken through
Linus' pinctrl branch. As there is no other platform than Dove 
involved, I suggest to take it though Jason's tree to avoid any
further conflicts.

Axel Lin (1):
  pinctrl: mvebu: Fix dove_audio1_ctrl_set function

Sebastian Hesselbarth (3):
  pinctrl: mvebu: fix iomem pointer for dove pinctrl
  ARM: Dove: Convert to DT GPIO and pinctrl
  ARM: Dove: Add CuBox pinhog for led

 arch/arm/Kconfig                     |    2 ++
 arch/arm/boot/dts/dove-cubox.dts     |   10 ++++++++++
 arch/arm/boot/dts/dove.dtsi          |   20 +++++++++++++++++---
 drivers/pinctrl/mvebu/pinctrl-dove.c |   22 +++++++++++++++-------
 4 files changed, 44 insertions(+), 10 deletions(-)
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Axel Lin <axel.lin@ingics.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4

