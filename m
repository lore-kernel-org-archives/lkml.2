Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2L1J35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 04:29:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7846 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2L1J3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 04:29:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 28 Dec 2012 01:26:28 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <sameo@linux.intel.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <lrg@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] mfd/regulator: tps65090: add DT support and suspend/resume cleanups
Date: Fri, 28 Dec 2012 14:59:37 +0530
Message-ID: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series add DT support on TPS65090 device.

Also remove the suspend/resume implementation as it duplicates with
irq_suspend/irq_resume().

Laxman Dewangan (4):
  mfd: tps65090: add DT support for tps65090
  regulator: tps65090: add DT support
  mfd: tps65090: Pass irq domain when adding mfd sub devices
  mfd: tps65090: remove suspend/resume callbacks

 .../devicetree/bindings/regulator/tps65090.txt     |  121 ++++++++++++++++++++
 drivers/mfd/tps65090.c                             |   77 ++++++++----
 drivers/regulator/tps65090-regulator.c             |   96 +++++++++++++++-
 include/linux/mfd/tps65090.h                       |    1 +
 4 files changed, 266 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/tps65090.txt

