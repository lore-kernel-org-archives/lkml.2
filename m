Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2KYURf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 15:17:35 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:57400 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab2KYURd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 15:17:33 -0500
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.hauer@pengutronix.de, julien.boibessot@armadeus.com,
        eric.jarrige@armadeus.org, Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH 0/4] apf27: enable Ethernet PHY and add support of ds1374 rtc
Date: Sun, 25 Nov 2012 21:17:01 +0100
Message-Id: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enable Ethernet PHY at startup, and add
the support of ds1374 rtc on armadeus apf27.

Philippe Reynes (4):
  apf27: enable Ethernet PHY
  ds1374: add support of device tree
  imx27-dt: configure i2c1 gpio on armadeus apf27
  apf27: add rtc ds1374 to the device tree

 arch/arm/boot/dts/imx27-apf27.dts |   10 ++++++++++
 arch/arm/mach-imx/imx27-dt.c      |   26 ++++++++++++++++++++++++++
 drivers/rtc/rtc-ds1374.c          |    8 ++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

-- 
1.7.4.4

