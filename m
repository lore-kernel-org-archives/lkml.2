Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2GXVBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:01:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62975 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2GXVBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:01:44 -0400
Message-ID: <500F0D34.6000907@gmail.com>
Date: Tue, 24 Jul 2012 16:01:40 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [GIT PULL] Devicetree for 3.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

While Grant's busy packing, please pull devicetree updates for 3.6.

Rob

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git tags/dt-for-3.6

for you to fetch changes up to e95d8aafa5d911bf523bc47fe89f3336eb8a1b51:

  of: mtd: nuke useless const qualifier (2012-07-10 10:32:06 -0500)

----------------------------------------------------------------
Devicetree updates for 3.6

A small set of changes for devicetree:
- Couple of Documentation fixes
- Addition of new helper function of_node_full_name
- Improve of_parse_phandle_with_args return values
- Some NULL related sparse fixes

----------------------------------------------------------------
Alexandre Courbot (1):
      of: return -ENOENT when no property

Artem Bityutskiy (1):
      of: mtd: nuke useless const qualifier

Grant Likely (1):
      devicetree: add helper inline for retrieving a node's full name

Marek Vasut (1):
      LED: Fix missing semicolon in OF documentation

Richard Genoud (1):
      usage-model.txt: fix typo machine_init->init_machine

Rob Herring (1):
      of: fix a few typos in the binding documentation

Sachin Kamat (1):
      of: Fix null pointer related warnings in base.c file

 Documentation/devicetree/bindings/gpio/led.txt     |    2 +-
 .../devicetree/bindings/mtd/partition.txt          |    2 +-
 Documentation/devicetree/usage-model.txt           |    2 +-
 arch/microblaze/pci/pci-common.c                   |    6 ++----
 arch/powerpc/kernel/pci-common.c                   |    6 ++----
 arch/powerpc/kernel/vio.c                          |    5 ++---
 arch/powerpc/platforms/cell/iommu.c                |    3 +--
 arch/powerpc/platforms/pseries/iommu.c             |    2 +-
 arch/sparc/kernel/of_device_64.c                   |    2 +-
 drivers/of/base.c                                  |   10 +++++-----
 drivers/of/irq.c                                   |    2 +-
 drivers/of/of_mtd.c                                |    2 +-
 include/linux/of.h                                 |   10 ++++++++++
 include/linux/of_mtd.h                             |    2 +-
 kernel/irq/irqdomain.c                             |    8 ++++----
 15 files changed, 34 insertions(+), 30 deletions(-)
