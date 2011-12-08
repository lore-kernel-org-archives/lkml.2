Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1LHJod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:44:33 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:53809 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1LHJo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:44:29 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH v3 0/4] mmx: mxs-mmc: Some cleanups and fixes for the MXS MMC subsystem
Date: Thu,  8 Dec 2011 10:44:12 +0100
Message-Id: <cover.1323336236.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lothar Waßmann (4):
  Fix grammatical error in comment
  Some cleanups for the MMC driver
  Check the return codes of clk_enable() and mxs_reset_block()
  Add an appropriate MODULE_ALIAS

Changes wrt v2:
 - add missing Acked-by's
 - changed subject-prefix

 drivers/mmc/host/mxs-mmc.c |   87 +++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

