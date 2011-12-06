Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab1LFK1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:27:38 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:51630 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LFK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:27:37 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH][NET] several cleanups and bugfixes for fec.c
Date: Tue,  6 Dec 2011 11:27:08 +0100
Message-Id: <cover.1323163127.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches provides some cleanup and bugfixes for
drivers/net/ethernet/freescale/fec.c and makes the driver buildable as
a module.

Lothar Waßmann (8):
  misc cleanups
  set con_id in clk_get() call to NULL
  prevent dobule restart of interface on FDX/HDX change
  don't request invalid IRQ
  don't munge MAC address from platform data
  preserve MII/RMII setting in fec_stop()
  fix the .remove code
  make FEC driver buildable as module

 drivers/net/ethernet/freescale/Kconfig |    2 +-
 drivers/net/ethernet/freescale/fec.c   |   63 ++++++++++++++++++++++----------
 2 files changed, 44 insertions(+), 21 deletions(-)

