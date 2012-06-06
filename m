Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab2FFWCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:02:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37605 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2FFWCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:02:20 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Doug Thompson <dougthompson@xmission.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/2] EDAC support for Calxeda Highbank
Date: Wed,  6 Jun 2012 17:02:03 -0500
Message-Id: <1339020125-20198-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series adds EDAC support for Calxeda Highbank platform L2 and
memory ECC hardware.

Rob

Rob Herring (2):
  edac: add support for Calxeda highbank memory controller
  edac: add support for Calxeda highbank L2 cache ecc

 .../devicetree/bindings/arm/calxeda/l2ecc.txt      |   17 ++
 .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt  |   17 ++
 arch/arm/boot/dts/highbank.dts                     |   12 +
 drivers/edac/Kconfig                               |   16 +-
 drivers/edac/Makefile                              |    4 +
 drivers/edac/highbank_l2_edac.c                    |  149 ++++++++++++
 drivers/edac/highbank_mc_edac.c                    |  238 ++++++++++++++++++++
 7 files changed, 452 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt
 create mode 100644 Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
 create mode 100644 drivers/edac/highbank_l2_edac.c
 create mode 100644 drivers/edac/highbank_mc_edac.c

-- 
1.7.9.5

