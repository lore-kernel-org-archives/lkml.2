Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2FLCcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:32:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2FLCcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:32:32 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: mchehab@redhat.com, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v2 0/3] EDAC support for Calxeda Highbank
Date: Mon, 11 Jun 2012 21:32:11 -0500
Message-Id: <1339468334-9927-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series adds EDAC support for Calxeda Highbank platform L2 and
memory ECC hardware.

This version is rebased current edac next tree for 3.6. Changes in
this version are the addition of a common edac debugfs directory and
coverting the highbank error injection to use debugfs.

Rob

Rob Herring (3):
  edac: create top-level debugfs directory
  edac: add support for Calxeda highbank memory controller
  edac: add support for Calxeda highbank L2 cache ecc

 .../devicetree/bindings/arm/calxeda/l2ecc.txt      |   17 ++
 .../devicetree/bindings/arm/calxeda/mem-ctrlr.txt  |   17 ++
 arch/arm/boot/dts/highbank.dts                     |   12 +
 drivers/edac/Kconfig                               |   16 +-
 drivers/edac/Makefile                              |    4 +
 drivers/edac/edac_mc_sysfs.c                       |   23 +-
 drivers/edac/edac_module.c                         |    3 +
 drivers/edac/edac_module.h                         |   14 ++
 drivers/edac/highbank_l2_edac.c                    |  149 ++++++++++++
 drivers/edac/highbank_mc_edac.c                    |  256 ++++++++++++++++++++
 10 files changed, 509 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/calxeda/l2ecc.txt
 create mode 100644 Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
 create mode 100644 drivers/edac/highbank_l2_edac.c
 create mode 100644 drivers/edac/highbank_mc_edac.c

-- 
1.7.9.5

