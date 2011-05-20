Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171Ab1ETEhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:37:21 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:34646 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443Ab1ETEhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:37:19 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 00/12] staging: usbip
Date: Thu, 19 May 2011 21:36:54 -0700
Message-Id: <cover.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

matt mooney (12):
  staging: usbip: replace usbip_u{dbg,err,info} and printk with dev_
    and pr_
  staging: usbip: remove unnecessary lines and extra return statements
  staging: usbip: stub_main.c: reorder functions
  staging: usbip: stub_main.c: code cleanup
  staging: usbip: stub_main.c: rename init and exit functions
  staging: usbip: stub_main.c: use KMEM_CACHE macro
  staging: usbip: usbip_common.c: fix misspelled function name
  staging: usbip: usbip_common.h: reorganize and document request
    headers
  staging: usbip: stub_dev.c: move stub_driver definition and update
    driver name
  staging: usbip: userspace: bind_driver.c: update kernel module name
  staging: usbip: usbip_common.c: rename init and exit functions
  staging: usbip: vhci_hcd.c: rename init and exit functions

 drivers/staging/usbip/stub.h                      |    1 +
 drivers/staging/usbip/stub_dev.c                  |   93 +++----
 drivers/staging/usbip/stub_main.c                 |  212 +++++++---------
 drivers/staging/usbip/stub_rx.c                   |   23 +-
 drivers/staging/usbip/stub_tx.c                   |   30 +-
 drivers/staging/usbip/usbip_common.c              |  257 +++++++++----------
 drivers/staging/usbip/usbip_common.h              |  284 +++++++++-----------
 drivers/staging/usbip/usbip_event.c               |    3 +-
 drivers/staging/usbip/userspace/src/bind-driver.c |    4 +-
 drivers/staging/usbip/vhci_hcd.c                  |  106 +++-----
 drivers/staging/usbip/vhci_rx.c                   |   35 ++--
 drivers/staging/usbip/vhci_sysfs.c                |   14 +-
 drivers/staging/usbip/vhci_tx.c                   |    8 +-
 13 files changed, 479 insertions(+), 591 deletions(-)

-- 
1.7.5.1

