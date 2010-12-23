Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0LWHYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 02:24:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33819 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab0LWHYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 02:24:07 -0500
From: pavan_savoy@ti.com
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: padovan@profusion.mobi, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/2] drivers:staging:ti-st: keep updated
Date: Thu, 23 Dec 2010 01:23:55 -0600
Message-Id: <1293089037-23130-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Greg,

Happy Holidays.
Re-ordering the patches as you suggested.

1. Adds the new btwilink driver
2. deletes the old driver and points it to new one.

This is all to keep the drivers/staging/ti-st/ directory updated,
and since the btwilink driver has undergone huge modifications,
there was an update required.

So parking the most recent version of driver here, while
underlying TI-ST driver modifications are carried out.

Pavan Savoy (2):
  drivers:staging: ti-st: add the v7 btwilink driver
  drivers:staging: ti-st: delete old bt_drv driver

 drivers/staging/ti-st/Makefile   |    2 +-
 drivers/staging/ti-st/bt_drv.c   |  509 --------------------------------------
 drivers/staging/ti-st/bt_drv.h   |   61 -----
 drivers/staging/ti-st/btwilink.c |  363 +++++++++++++++++++++++++++
 4 files changed, 364 insertions(+), 571 deletions(-)
 delete mode 100644 drivers/staging/ti-st/bt_drv.c
 delete mode 100644 drivers/staging/ti-st/bt_drv.h
 create mode 100644 drivers/staging/ti-st/btwilink.c

