Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab1LHISA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:18:00 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:49274 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1LHIR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:17:59 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [MXS MMC v2 0/4] Some cleanups and fixes for the MXS MMC subsystem
Date: Thu,  8 Dec 2011 09:17:43 +0100
Message-Id: <cover.1323328267.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lothar Waßmann (4):
  Fix grammatical error in comment
  Some cleanups for the MMC driver
  Check the return codes of clk_enable() and mxs_reset_block()
  Add an appropriate MODULE_ALIAS

Changes wrt v1:
 - omitted patch 3 "Add support for MMC ports 2 & 3" which has already
   been applied by Shawn Guo
 - fix checkpatch warnings in patch 2 and leave indentation as is
 - add Acked-by: where applicable

 drivers/mmc/host/mxs-mmc.c |   87 +++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

