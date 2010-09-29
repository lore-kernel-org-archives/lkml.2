Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0I2QX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:23:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41355 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab0I2QX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:23:27 -0400
Date: Wed, 29 Sep 2010 18:23:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH 0/4] mfd/mc13xxx: cleanups and support for mc13892
Message-ID: <20100929162315.GG29811@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this series adds support for the mc13892 PMIC found as companion e.g. on
the MX51 Babbage board.  Additionally it includes a few minor cleanups.

Unfortunately the changes done are too heavy for git to detect the
renaming.

The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:

  Linux 2.6.36-rc6 (2010-09-28 18:01:22 -0700)

are available in the git repository at:
  git://git.pengutronix.de/git/ukl/linux-2.6.git next/mc13xxx

Uwe Kleine-König (4):
      mfd/mc13783: remove obsolete private data
      mfd/mc13783: remove deprecated functions
      mfd/mc13xxx: add support for mc13892
      rtc/mc13xxx: add support for the rtc found in the MC13892 PMIC

 drivers/mfd/Kconfig         |    9 +-
 drivers/mfd/Makefile        |    2 +-
 drivers/mfd/mc13783-core.c  |  752 --------------------------------------
 drivers/mfd/mc13xxx-core.c  |  840 +++++++++++++++++++++++++++++++++++++++++++
 drivers/rtc/Kconfig         |    7 +-
 drivers/rtc/Makefile        |    2 +-
 drivers/rtc/rtc-mc13783.c   |  428 ----------------------
 drivers/rtc/rtc-mc13xxx.c   |  437 ++++++++++++++++++++++
 include/linux/mfd/mc13783.h |  239 +++++--------
 include/linux/mfd/mc13xxx.h |  154 ++++++++
 10 files changed, 1542 insertions(+), 1328 deletions(-)
 delete mode 100644 drivers/mfd/mc13783-core.c
 create mode 100644 drivers/mfd/mc13xxx-core.c
 delete mode 100644 drivers/rtc/rtc-mc13783.c
 create mode 100644 drivers/rtc/rtc-mc13xxx.c
 create mode 100644 include/linux/mfd/mc13xxx.h

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
