Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1JSW7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:59:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56433 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab1JSW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:59:21 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] Resend previous incorrecly formatted patches
Date: Wed, 19 Oct 2011 23:57:09 +0100
Message-Id: <1319065048-2767-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending patches, these have now been formatted with:

git format-patch -k -M

Tested with git am sucessfully on a local tree

Mark Einon (19):
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
      staging: et131x: Moving two extern inline functions to .c file
      staging: et131x: Make rx_ring.fbr{0,1} share a common structure
      staging: et131x: Fix issues when USE_FBR0 is not defined
      staging: et131x: use dma_alloc... instead of pci_alloc...
      staging: et131x: Match dma_alloc_ calls with dma_free_ calls
      staging: et131x: Tidy up PCI device table definition
      staging: et131x: on transmit, stop the queue if the next packet will fail
      staging: et131x: Convert rest of pci memory management to dma api
      staging: et131x: Remove unused defines

 drivers/staging/et131x/Makefile             |   11 -
 drivers/staging/et131x/README               |    5 -
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
 drivers/staging/et131x/et131x.c             | 5577 +++++++++++++++++++++++++++
 drivers/staging/et131x/et131x.h             | 1718 ++++++++-
 drivers/staging/et131x/et131x_adapter.h     |  218 --
 drivers/staging/et131x/et131x_defs.h        |  128 -
 drivers/staging/et131x/et131x_ethtool.c     |  201 -
 drivers/staging/et131x/et131x_initpci.c     |  950 -----
 drivers/staging/et131x/et131x_isr.c         |  442 ---
 drivers/staging/et131x/et131x_netdev.c      |  662 ----
 20 files changed, 7192 insertions(+), 8437 deletions(-)

