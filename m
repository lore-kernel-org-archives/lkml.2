Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2GPJuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:50:05 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:43449 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271Ab2GPJuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:50:01 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 0/2] MFD: twl6040: Version support fixes, additions
Date: Mon, 16 Jul 2012 11:49:42 +0200
Message-Id: <1342432184-12046-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following series fixes the revision information for twl6040 and adds support
for twl6041.

While the first patch is changing a driver in sound/soc/codecs the series can go
via MFD since we do not have pending patches for twl6040 audio part for 3.6.

Regards,
Peter
---
Peter Ujfalusi (2):
  MFD: twl6040: Fix revision information
  MFD: twl6040: Add support for twl6041

 Documentation/devicetree/bindings/mfd/twl6040.txt |    2 +-
 drivers/mfd/twl6040-core.c                        |    1 +
 include/linux/mfd/twl6040.h                       |    5 +++--
 sound/soc/codecs/twl6040.c                        |    2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

-- 
1.7.8.6

