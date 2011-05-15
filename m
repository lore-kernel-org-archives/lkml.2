Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1EOKpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 06:45:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab1EOKpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 06:45:24 -0400
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se, tomas.winkler@intel.com,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 00/10] staging/mei: Intel MEI Driver
Date: Sun, 15 May 2011 13:43:38 +0300
Message-Id: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Intel MEI Driver
===============

This second try to submit the Intel MEI Driver to the staging.
Most of the work was done in mei.txt file to describe the driver 
functionality and flows.
TODO file was updated with steps we believe need to be done.
We also hope that patches have better descriptions to help with review.
Some reorganization of header files was also preformed.

Thanks
	Oren Weil
	Intel Corporation.

Oren Weil (10):
  staging/mei: MEI Driver documentations
  staging/mei: MEI Driver TODO list
  staging/mei: PCI device and char driver support.
  staging/mei: Interrupt handling.
  staging/mei: MEI link layer
  staging/mei: MEI driver init flow.
  staging/mei: Hardware and MEI driver internal struct definition
  staging/mei: mei.h defining user space interface
  staging/mei: AMT Watchdog
  staging/mei: add mei to staging Kbuild

 drivers/staging/Kconfig           |    2 +
 drivers/staging/Makefile          |    1 +
 drivers/staging/mei/Kconfig       |   28 +
 drivers/staging/mei/Makefile      |   11 +
 drivers/staging/mei/TODO          |   17 +
 drivers/staging/mei/hw.h          |  333 ++++++++
 drivers/staging/mei/init.c        |  770 ++++++++++++++++++
 drivers/staging/mei/interface.c   |  447 ++++++++++
 drivers/staging/mei/interface.h   |   62 ++
 drivers/staging/mei/interrupt.c   | 1624 +++++++++++++++++++++++++++++++++++++
 drivers/staging/mei/iorw.c        |  604 ++++++++++++++
 drivers/staging/mei/main.c        | 1349 ++++++++++++++++++++++++++++++
 drivers/staging/mei/mei.h         |  105 +++
 drivers/staging/mei/mei.txt       |  189 +++++
 drivers/staging/mei/mei_dev.h     |  422 ++++++++++
 drivers/staging/mei/mei_version.h |   31 +
 drivers/staging/mei/wd.c          |  183 +++++
 17 files changed, 6178 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/mei/Kconfig
 create mode 100644 drivers/staging/mei/Makefile
 create mode 100644 drivers/staging/mei/TODO
 create mode 100644 drivers/staging/mei/hw.h
 create mode 100644 drivers/staging/mei/init.c
 create mode 100644 drivers/staging/mei/interface.c
 create mode 100644 drivers/staging/mei/interface.h
 create mode 100644 drivers/staging/mei/interrupt.c
 create mode 100644 drivers/staging/mei/iorw.c
 create mode 100644 drivers/staging/mei/main.c
 create mode 100644 drivers/staging/mei/mei.h
 create mode 100644 drivers/staging/mei/mei.txt
 create mode 100644 drivers/staging/mei/mei_dev.h
 create mode 100644 drivers/staging/mei/mei_version.h
 create mode 100644 drivers/staging/mei/wd.c

