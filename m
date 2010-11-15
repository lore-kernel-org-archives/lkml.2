Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab0KOUOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:14:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1334 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556Ab0KOUOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:07 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 00/11] Remove unnecessary casts of pci_get_drvdata
Date: Mon, 15 Nov 2010 12:13:51 -0800
Message-Id: <cover.1289851770.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (11):
  drivers/i2c/busses/i2c-nforce2.c: Remove unnecessary casts of pci_get_drvdata
  drivers/ide/pmac.c: Remove unnecessary casts of pci_get_drvdata
  drivers/media/dvb/ngene/ngene-core.c: Remove unnecessary casts of pci_get_drvdata
  drivers/misc/ibmasm/module.c: Remove unnecessary casts of pci_get_drvdata
  drivers/net/irda: Remove unnecessary casts of pci_get_drvdata
  drivers/net/s2io.c: Remove unnecessary casts of pci_get_drvdata
  drivers/net/vxge/vxge-main.c: Remove unnecessary casts of pci_get_drvdata
  drivers/scsi/be2iscsi/be_main.c: Remove unnecessary casts of pci_get_drvdata
  drivers/staging: Remove unnecessary casts of pci_get_drvdata
  drivers/usb/host/uhci-hcd.c: Remove unnecessary casts of pci_get_drvdata
  sound/pci/asihpi/hpioctl.c: Remove unnecessary casts of pci_get_drvdata

 drivers/i2c/busses/i2c-nforce2.c          |    2 +-
 drivers/ide/pmac.c                        |    4 ++--
 drivers/media/dvb/ngene/ngene-core.c      |    2 +-
 drivers/misc/ibmasm/module.c              |    2 +-
 drivers/net/irda/donauboe.c               |    6 +++---
 drivers/net/irda/vlsi_ir.c                |    2 +-
 drivers/net/s2io.c                        |    3 +--
 drivers/net/vxge/vxge-main.c              |   28 ++++++++++++----------------
 drivers/scsi/be2iscsi/be_main.c           |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.c |    6 +++---
 drivers/staging/et131x/et131x_initpci.c   |    2 +-
 drivers/staging/wlags49_h2/wl_pci.c       |    2 +-
 drivers/usb/host/uhci-hcd.c               |    2 +-
 sound/pci/asihpi/hpioctl.c                |    2 +-
 14 files changed, 30 insertions(+), 35 deletions(-)

-- 
1.7.3.1.g432b3.dirty

