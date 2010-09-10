Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0IJSr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:47:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50614 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab0IJSry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:47:54 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] drivers:staging:ti-st: patches
Date: Fri, 10 Sep 2010 15:58:54 -0400
Message-Id: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Greg,

There are 2 patch sets here,
1) fixes a problem - has only 1 patch
2) set of 3 patches subjected as RFCs

Please merge the patch below, and provide comments on the rest.

Pavan Savoy (1):
  drivers:staging:ti-st: fix kim platform device id

 drivers/staging/ti-st/st_kim.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

>From 801919830d6d707f4171a28720b3f4cc5348e192 Mon Sep 17 00:00:00 2001
From: Pavan Savoy <pavan_savoy@ti.com>
Date: Fri, 10 Sep 2010 14:43:03 -0400
Subject: [RFC 0/3] *** SUBJECT HERE ***

*** BLURB HERE ***

Pavan Savoy (3):
  drivers:staging:ti-st: mv headers to ti_wilink_st
  drivers:staging:ti-st: mv ti_wilink_st to include/
  include:linux: make ti_wilink_st like the rest

 drivers/staging/ti-st/bt_drv.c  |    2 +-
 drivers/staging/ti-st/fm.h      |   13 --
 drivers/staging/ti-st/st.h      |   83 --------
 drivers/staging/ti-st/st_core.c |   12 +-
 drivers/staging/ti-st/st_core.h |  128 ------------
 drivers/staging/ti-st/st_kim.c  |    8 +-
 drivers/staging/ti-st/st_kim.h  |  180 -----------------
 drivers/staging/ti-st/st_ll.c   |    6 +-
 drivers/staging/ti-st/st_ll.h   |   69 -------
 include/linux/ti_wilink_st.h    |  411 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 421 insertions(+), 491 deletions(-)
 delete mode 100644 drivers/staging/ti-st/fm.h
 delete mode 100644 drivers/staging/ti-st/st.h
 delete mode 100644 drivers/staging/ti-st/st_core.h
 delete mode 100644 drivers/staging/ti-st/st_kim.h
 delete mode 100644 drivers/staging/ti-st/st_ll.h
 create mode 100644 include/linux/ti_wilink_st.h

