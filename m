Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab0LNMGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:06:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36030 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab0LNMGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:06:50 -0500
From: pavan_savoy@ti.com
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: padovan@profusion.mobi, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/2] keep ti-st staging updated
Date: Tue, 14 Dec 2010 06:06:38 -0600
Message-Id: <1292328400-7649-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Greg,

In my attempt to upstream BT driver based on TI ST driver,
I had posted several patches to linux-bluetooth.

At this point, there are no review comments as such specifically
to bluetooth driver but there are few concerns regarding the TI-ST driver itself.

As I await the responses from Gustavo, Marcel on how best to proceed
in improving btwilink driver, I am deleting the very old bt_drv from
the staging and updating it with relatively acceptable btwilink driver.

Pavan Savoy (2):
  drivers:staging: ti-st: remove bt_drv
  drivers:staging: ti-st: update the TI ST BT driver

 drivers/staging/ti-st/Kconfig    |   25 +-
 drivers/staging/ti-st/Makefile   |    6 +-
 drivers/staging/ti-st/bt_drv.c   |  509 --------------------------------------
 drivers/staging/ti-st/bt_drv.h   |   61 -----
 drivers/staging/ti-st/btwilink.c |  363 +++++++++++++++++++++++++++
 drivers/staging/ti-st/sysfs-uim  |   28 --
 6 files changed, 376 insertions(+), 616 deletions(-)
 delete mode 100644 drivers/staging/ti-st/bt_drv.c
 delete mode 100644 drivers/staging/ti-st/bt_drv.h
 create mode 100644 drivers/staging/ti-st/btwilink.c
 delete mode 100644 drivers/staging/ti-st/sysfs-uim

