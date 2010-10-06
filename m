Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab0JFPFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:05:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56432 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab0JFPFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:05:32 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 0/2] move TI_ST driver out of staging
Date: Wed,  6 Oct 2010 12:18:13 -0400
Message-Id: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Greg,

As suggested, I've squashed the 4 patches into a set of 2 patches.
1. moves the source files.
2. moves/modifies the Kconfig and Makefiles.

Please review.

Thanks & Regards,
Pavan Savoy

Pavan Savoy (2):
  drivers:staging:ti-st: move TI_ST from staging
  drivers:misc: ti-st: Kconfig & Makefile for TI_ST

 drivers/misc/Kconfig            |    1 +
 drivers/misc/Makefile           |    1 +
 drivers/misc/ti-st/Kconfig      |   17 +
 drivers/misc/ti-st/Makefile     |    6 +
 drivers/misc/ti-st/st_core.c    | 1031 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/ti-st/st_kim.c     |  798 ++++++++++++++++++++++++++++++
 drivers/misc/ti-st/st_ll.c      |  150 ++++++
 drivers/staging/ti-st/Kconfig   |   11 -
 drivers/staging/ti-st/Makefile  |    2 -
 drivers/staging/ti-st/st_core.c | 1030 --------------------------------------
 drivers/staging/ti-st/st_kim.c  |  797 ------------------------------
 drivers/staging/ti-st/st_ll.c   |  149 ------
 12 files changed, 2004 insertions(+), 1989 deletions(-)
 create mode 100644 drivers/misc/ti-st/Kconfig
 create mode 100644 drivers/misc/ti-st/Makefile
 create mode 100644 drivers/misc/ti-st/st_core.c
 create mode 100644 drivers/misc/ti-st/st_kim.c
 create mode 100644 drivers/misc/ti-st/st_ll.c
 delete mode 100644 drivers/staging/ti-st/st_core.c
 delete mode 100644 drivers/staging/ti-st/st_kim.c
 delete mode 100644 drivers/staging/ti-st/st_ll.c

