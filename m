Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2EHLdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:33:33 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:37952 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627Ab2EHLdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:33:32 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        peter.ujfalusi@ti.com
Subject: [PATCH v2 0/3] MFD: twl6040: Device tree support
Date: Tue,  8 May 2012 14:33:27 +0300
Message-Id: <1336476810-26945-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v1:
- Commit message for patch 2 (Allocate IRQ numbers dynamically) has been updated
  to describe that the twl6040 can not be used as IRQ extender type of device.

Commit message from v1:

The following series adds device tree support for the twl6040 MFD core driver.
Support for the child drivers (vibra, ASoC codec) will be submitted via the
corresponding subsystem since there is no compile time dependency between them.

The first patch is a minor clean up patch to remove wrapped lines in the
twl6040-irq.c. The resulting code is more natural to read to me.

The series depends on the regulator support patch for the twl6040:
http://marc.info/?l=linux-kernel&m=133596703610515&w=2

Regards,
Peter
---
Peter Ujfalusi (3):
  MFD: twl6040: Code cleanup in interrupt initialization part
  MFD: twl6040: Allocate IRQ numbers dynamically
  MFD: twl6040: Support for DT

 Documentation/devicetree/bindings/mfd/twl6040.txt |   51 +++++++++++++++++++++
 drivers/mfd/twl6040-core.c                        |   26 +++++++---
 drivers/mfd/twl6040-irq.c                         |   32 +++++++++----
 3 files changed, 92 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl6040.txt

-- 
1.7.8.6

