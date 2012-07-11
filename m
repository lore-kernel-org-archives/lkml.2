Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2GKUl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:41:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44458 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab2GKUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:41:25 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <j-keerthy@ti.com>, <grant.likely@secretlab.ca>, <b-cousson@ti.com>,
        <kbaidarov@dev.rtsoft.ru>, Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv3 0/4] staging: adding OMAP bandgap driver
Date: Wed, 11 Jul 2012 23:41:05 +0300
Message-ID: <1342039269-13968-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On top of the compilation fix, now Keerthy's SOB is just like
in the files' copyright notice. I also changed patch 01 so that
it does not add an empty line in the end of the Kconfig, so
patches 01 and 02 are different from V2. That's why I sent the
complete series with v3 mark.

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

