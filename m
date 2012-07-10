Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2GJNcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:32:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60065 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab2GJNcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:32:12 -0400
From: Chandrabhanu Mahapatra <cmahapatra@ti.com>
To: <rob.herring@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <leed.aguilar@ti.com>, Chandrabhanu Mahapatra <cmahapatra@ti.com>
Subject: [PATCH 0/4] Extend TCA6424 support
Date: Tue, 10 Jul 2012 19:01:33 +0530
Message-ID: <cover.1341925681.git.cmahapatra@ti.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone!
This following patch series extends support capabilities of TCA6424 through
following patches.

The 1st patch adds 24 bit support for polarity inversion registers by providing
24 bit support for invert variable.
The 2nd patch adds 24 bit support of the variables such as irq_mask, irq_stat, etc.
The 3rd patch extends 24 lines irq support for TCA6424.
The 4th patch corrects the implementation of registration of device irqs using
appropiate api's.

These patches were based on mainline kernel v3.5rc6.

All your comments and suggestions are welcome.

Regards,
Chandrabhanu

Chandrabhanu Mahapatra (1):
  GPIO: PCA953X: Increase size of invert variable to support 24 bit

Leed Aguilar (3):
  gpio/pca953x: increase variables size to support 24 bit of data
  OMAP: Define TCA6424 max number of possible IRQs
  gpio/pca953x: register the device irq using appropriate api's

 arch/arm/plat-omap/include/plat/irqs.h |   11 +++++++-
 drivers/gpio/gpio-pca953x.c            |   47 ++++++++++++++++++--------------
 include/linux/i2c/pca953x.h            |    2 +-
 3 files changed, 38 insertions(+), 22 deletions(-)

-- 
1.7.10

