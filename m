Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2GRJUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:20:25 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:46882 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab2GRJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:20:18 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, peter.ujfalusi@ti.com
Subject: [PATCH 0/3] MFD/GPIO: Add twl6040 GPO driver
Date: Wed, 18 Jul 2012 11:20:17 +0200
Message-Id: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following series adds support for the GPO (General Purpose Output) on the
twl6040/41 audio chip.
The series has been tested on SDP4430, compile tested for x86_64 and x86_32 bit
to be sure it does not introduce build breakage.

The series depends on pending changes going through the MFD tree (twl6040
revision fixes, twl6041 support).

Linus, Grant, Samuel: Would it be possible to queue this series via the MFD tree
to avoid merge issues? It applies cleanly on top of gpio-next I believe it will
not cause problems via MFD.

Regards,
Peter
---
Peter Ujfalusi (3):
  mfd: twl6040: Fix GPO mask
  mfd: twl6040: Add twl6040-gpio child
  gpio: Add basic support for TWL6040 GPOs

 Documentation/devicetree/bindings/mfd/twl6040.txt |    4 +
 drivers/gpio/Kconfig                              |    7 +
 drivers/gpio/Makefile                             |    1 +
 drivers/gpio/gpio-twl6040.c                       |  137 +++++++++++++++++++++
 drivers/mfd/twl6040-core.c                        |   27 ++++
 include/linux/mfd/twl6040.h                       |   11 ++-
 6 files changed, 185 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpio/gpio-twl6040.c

-- 
1.7.8.6

