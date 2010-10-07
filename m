Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab0JGReV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:34:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56725 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0JGReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:34:19 -0400
From: pavan_savoy@ti.com
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/2] v2: Bluetooth driver for TI_ST
Date: Thu,  7 Oct 2010 14:47:15 -0400
Message-Id: <1286477237-7526-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Marcel,

I have taken care of the changes you've mentioned, Now the
bluetooth driver is also a platform driver and it requires a
platform device and this platform driver's probe will do the
registration to HCI.

other changes include the usage of BT_DBG instead of pr_*
and removal of piece of code which was redundant.

Please review and comment...

Pavan Savoy (2):
  drivers:bluetooth: TI_ST bluetooth driver
  drivers:bluetooth: Kconfig & Makefile for TI BT

 drivers/bluetooth/Kconfig  |   10 +
 drivers/bluetooth/Makefile |    1 +
 drivers/bluetooth/bt_ti.c  |  489 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 500 insertions(+), 0 deletions(-)
 create mode 100644 drivers/bluetooth/bt_ti.c

