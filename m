Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1JLVix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:38:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39693 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1JLViw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:38:52 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] staging: et131x: Move driver into one file
Date: Wed, 12 Oct 2011 22:36:32 +0100
Message-Id: <1318455402-10596-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set moves all driver code into one file, and all register defines
into one header file.

Mark Einon (10):
      staging: et131x: Put all .c files into one big file
      staging: et131x: Move function declarations from et131x.h to et131x.c
      staging: et131x: Move non-register defines from et131x.h to et131x.c
      staging: et131x: move et1310_address_map.h contents into et131x.h
      staging: et131x: move et1310_phy.h contents into et131x.h
      staging: et131x: move et131x_adapter.h contents into et131x.c
      staging: et131x: move et131x_defs.h contents into et131x.c
      staging: et131x: move et1310_rx.h contents into et131x.c
      staging: et131x: move et1310_tx.h contents into et131x.c
      staging: et131x: Update TODO list - remove 'put driver into single file'

 drivers/staging/et131x/Makefile             |   11 -
 drivers/staging/et131x/README               |    1 -
 drivers/staging/et131x/et1310_address_map.h | 1436 -------
 drivers/staging/et131x/et1310_eeprom.c      |  408 --
 drivers/staging/et131x/et1310_mac.c         |  654 ----
 drivers/staging/et131x/et1310_phy.c         |  375 --
 drivers/staging/et131x/et1310_phy.h         |  292 --
 drivers/staging/et131x/et1310_pm.c          |  204 -
 drivers/staging/et131x/et1310_rx.c          | 1160 ------
 drivers/staging/et131x/et1310_rx.h          |  245 --
 drivers/staging/et131x/et1310_tx.c          |  793 ----
 drivers/staging/et131x/et1310_tx.h          |  150 -
 drivers/staging/et131x/et131x.c             | 5578 +++++++++++++++++++++++++++
 drivers/staging/et131x/et131x.h             | 1728 ++++++++-
 drivers/staging/et131x/et131x_adapter.h     |  218 --
 drivers/staging/et131x/et131x_defs.h        |  128 -
 drivers/staging/et131x/et131x_ethtool.c     |  201 -
 drivers/staging/et131x/et131x_initpci.c     |  950 -----
 drivers/staging/et131x/et131x_isr.c         |  442 ---
 drivers/staging/et131x/et131x_netdev.c      |  662 ----
 20 files changed, 7203 insertions(+), 8433 deletions(-)
