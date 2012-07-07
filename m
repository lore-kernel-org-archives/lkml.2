Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2GGH6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 03:58:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35813 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab2GGH6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 03:58:42 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <j-keerthy@ti.com>, <grant.likely@secretlab.ca>, <b-cousson@ti.com>,
        <kbaidarov@dev.rtsoft.ru>, Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 0/4] staging: adding OMAP bandgap driver
Date: Sat, 7 Jul 2012 10:57:48 +0300
Message-ID: <1341647872-15267-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Here is the reworked series with the omap bangap driver and minimalist
thermal framework support. Diff from v1 is simple that now it won't
break compilation. Only change is between patch 1 and patch 2, I have
added the missing and needed Makefile and Kconfig entries in patch 1,
for omap-bandgap.c.

Cheers,

Eduardo Valentin (4):
  staging: OMAP4+: thermal: introduce bandgap temperature sensor
  staging: omap-thermal: common code to expose driver to thermal
    framework
  staging: omap-thermal: add OMAP4 data structures
  staging: omap-thermal: add OMAP5 data structures

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/omap-thermal/Kconfig               |   45 +
 drivers/staging/omap-thermal/Makefile              |    5 +
 drivers/staging/omap-thermal/TODO                  |   27 +
 drivers/staging/omap-thermal/omap-bandgap.c        | 1186 ++++++++++++++++++++
 drivers/staging/omap-thermal/omap-bandgap.h        |  441 ++++++++
 drivers/staging/omap-thermal/omap-thermal-common.c |  397 +++++++
 drivers/staging/omap-thermal/omap-thermal.h        |  108 ++
 drivers/staging/omap-thermal/omap4-thermal.c       |  259 +++++
 drivers/staging/omap-thermal/omap5-thermal.c       |  297 +++++
 drivers/staging/omap-thermal/omap_bandgap.txt      |   30 +
 12 files changed, 2798 insertions(+), 0 deletions(-)
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

