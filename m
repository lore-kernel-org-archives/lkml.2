Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab1LFNmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:42:02 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64339 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab1LFNmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:42:00 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [MXS MMC 0/5] Some cleanups and fixes for the MXS MMC subsystem
Date: Tue,  6 Dec 2011 14:41:25 +0100
Message-Id: <cover.1323177907.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lothar Waßmann (5):
  Fix grammatical error in comment
  Some cleanups for the MMC driver
  Add support for SSP/MMC ports 2 & 3
  Check the return codes of clk_enable() and mxs_reset_block()
  Add an appropriate MODULE_ALIAS

 arch/arm/mach-mxs/clock-mx28.c               |    6 ++-
 arch/arm/mach-mxs/devices/platform-mxs-mmc.c |    2 +
 drivers/mmc/host/mxs-mmc.c                   |   84 +++++++++++++++----------
 3 files changed, 57 insertions(+), 35 deletions(-)

