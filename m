Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1EFKyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:20 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:37670 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386Ab1EFKyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:18 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 00/16] staging: usbip: cleanup
Date: Fri,  6 May 2011 03:47:40 -0700
Message-Id: <cover.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here is a set of extremely trivial changes; more substantial changes
will follow.

Thanks,
matt

matt mooney (16):
  staging: usbip: stub_dev.c: coding style cleanup
  staging: usbip: stub_main.c: coding style cleanup
  staging: usbip: stub_rx.c: coding style cleanup
  staging: usbip: stub_tx.c: coding style cleanup
  staging: usbip: usbip_common.h: coding style cleanup
  staging: usbip: usbip_common.c: coding style cleanup
  staging: usbip: usbip_event.c: coding style cleanup
  staging: usbip: stub.h: coding style cleanup
  staging: usbip: vhci.h: coding style cleanup
  staging: usbip: vhci_hcd.c: coding style cleanup
  staging: usbip: vhci_rx.c: coding style cleanup
  staging: usbip: vhci_sysfs.c: coding style cleanup
  staging: usbip: vhci_tx.c: coding style cleanup
  staging: usbip: add break to default case in switch statements
  staging: usbip: remove section dividers
  staging: usbip: fixup MODULE_ macros

 drivers/staging/usbip/stub.h         |    5 -
 drivers/staging/usbip/stub_dev.c     |   57 ++--------
 drivers/staging/usbip/stub_main.c    |   31 +----
 drivers/staging/usbip/stub_rx.c      |   52 ++++-----
 drivers/staging/usbip/stub_tx.c      |   68 ++++-------
 drivers/staging/usbip/usbip_common.c |  138 ++++++++++-------------
 drivers/staging/usbip/usbip_common.h |   85 +++++---------
 drivers/staging/usbip/usbip_event.c  |   18 +--
 drivers/staging/usbip/vhci.h         |   24 +---
 drivers/staging/usbip/vhci_hcd.c     |  204 +++++++++++++---------------------
 drivers/staging/usbip/vhci_rx.c      |   49 +++------
 drivers/staging/usbip/vhci_sysfs.c   |   15 +--
 drivers/staging/usbip/vhci_tx.c      |   36 ++----
 13 files changed, 278 insertions(+), 504 deletions(-)

-- 
1.7.5.1

