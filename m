Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030711Ab2GLQCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:02:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56160 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030696Ab2GLQCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:02:49 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <j-keerthy@ti.com>, <grant.likely@secretlab.ca>, <b-cousson@ti.com>,
        <kbaidarov@dev.rtsoft.ru>, Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv4 0/4] staging: adding OMAP bandgap driver
Date: Thu, 12 Jul 2012 19:02:28 +0300
Message-ID: <1342108952-12987-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Here is again the OMAP BG driver, under staging area.
I fixed the compilation issue I didn't see, wrt implicit function
declarations. As I mentioned on other thread, my compilation test
didn't see it, that's why I thought it was fine to send it.

I also limited the driver compilation to OMAP4/5.

Cheers,

Eduardo Valentin (4):
  staging: OMAP4+: thermal: introduce bandgap temperature sensor
  staging: omap-thermal: common code to expose driver to thermal
    framework
  staging: omap-thermal: add OMAP4 data structures
  staging: omap-thermal: add OMAP5 data structures

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/omap-thermal/Kconfig               |   46 +
 drivers/staging/omap-thermal/Makefile              |    5 +
 drivers/staging/omap-thermal/TODO                  |   28 +
 drivers/staging/omap-thermal/omap-bandgap.c        | 1187 ++++++++++++++++++++
 drivers/staging/omap-thermal/omap-bandgap.h        |  441 ++++++++
 drivers/staging/omap-thermal/omap-thermal-common.c |  364 ++++++
 drivers/staging/omap-thermal/omap-thermal.h        |  108 ++
 drivers/staging/omap-thermal/omap4-thermal.c       |  259 +++++
 drivers/staging/omap-thermal/omap5-thermal.c       |  297 +++++
 drivers/staging/omap-thermal/omap_bandgap.txt      |   30 +
 12 files changed, 2768 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/omap-thermal/Kconfig
 create mode 100644 drivers/staging/omap-thermal/Makefile
 create mode 100644 drivers/staging/omap-thermal/TODO
 create mode 100644 drivers/staging/omap-thermal/omap-bandgap.c
 create mode 100644 drivers/staging/omap-thermal/omap-bandgap.h
 create mode 100644 drivers/staging/omap-thermal/omap-thermal-common.c
 create mode 100644 drivers/staging/omap-thermal/omap-thermal.h
 create mode 100644 drivers/staging/omap-thermal/omap4-thermal.c
 create mode 100644 drivers/staging/omap-thermal/omap5-thermal.c
 create mode 100644 drivers/staging/omap-thermal/omap_bandgap.txt

-- 
1.7.7.1.488.ge8e1c

