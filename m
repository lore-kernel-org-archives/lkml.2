Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2IYACr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:02:47 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53204 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2IYACq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:02:46 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Dove fixes for arm-soc/for-next
Date: Tue, 25 Sep 2012 02:02:12 +0200
Message-Id: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current speed of changes within arm kernel tree, there
have been some issues related to the mach-dove DT support patches
introduced lately. This patch set keeps up with the changes between
initial patch submission and current status of arm-soc/for-next.

Sebastian Hesselbarth (6):
  ARM: dove: Add pcie clock support
  ARM: dove: Fix tauros2 device tree init
  ARM: dove: Fix clock names of sata and gbe
  ARM: dove: Restructure SoC device tree descriptor
  ARM: dove: Remove watchdog from DT
  ARM: dove: Add crypto engine to DT

 arch/arm/boot/dts/dove.dtsi |   49 ++++++++++++++++++++++++++++---------------
 arch/arm/mach-dove/common.c |    8 +++----
 arch/arm/mach-dove/pcie.c   |    5 +++++
 3 files changed, 41 insertions(+), 21 deletions(-)

---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4

