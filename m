Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab0JFVWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:22:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57329 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838Ab0JFVWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:22:01 -0400
From: pavan-savoy@ti.com
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@gmail.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/2] Bluetooth driver for TI WiLink 7
Date: Wed,  6 Oct 2010 18:34:51 -0400
Message-Id: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Marcel/Johan and the linux-bluetooth list,

I have begun cleaning up the code for the Bluetooth drivers for
Texas Instrument's WiLink 7 chips.
This driver works on top the Texas Instrument's shared transport line
discipline driver.

So, apart from the transport part of it, the driver is like other regular
bluetooth drivers.
These patches is to move it out of staging/ into the drivers/bluetooth/

Please review and provide comments.

Pavan Savoy (2):
  drivers:bluetooth: TI_ST bluetooth driver
  drivers:bluetooth: Kconfig & Makefile for TI BT

 drivers/bluetooth/Kconfig      |   11 +
 drivers/bluetooth/Makefile     |    1 +
 drivers/bluetooth/bt_ti.c      |  464 ++++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/Kconfig  |   14 -
 drivers/staging/ti-st/Makefile |    5 -
 drivers/staging/ti-st/bt_drv.c |  509 ----------------------------------------
 drivers/staging/ti-st/bt_drv.h |   61 -----
 7 files changed, 476 insertions(+), 589 deletions(-)
 create mode 100644 drivers/bluetooth/bt_ti.c
 delete mode 100644 drivers/staging/ti-st/Kconfig
 delete mode 100644 drivers/staging/ti-st/Makefile
 delete mode 100644 drivers/staging/ti-st/bt_drv.c
 delete mode 100644 drivers/staging/ti-st/bt_drv.h

