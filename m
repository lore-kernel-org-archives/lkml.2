Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0JEJnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:43:45 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21257 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab0JEJnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:43:43 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] BH1770GLC, SFH7770 and APDS990x als / proximity sensor drivers
Date: Tue,  5 Oct 2010 12:42:54 +0300
Message-Id: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 05 Oct 2010 09:43:02.0464 (UTC) FILETIME=[B4072400:01CB6471]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch set contains two drivers. One for BH1770GLC / SFH7770 chips and
one for APDS990X chip.

Both drivers have similar sysfs based interface. Both supports
pm_runtime and regulator frame work. There is short documentation
for both drivers.

Unfortunately I can't promise data sheets to public access.

Samu Onkalo (5):
  misc: Driver for bh1770glc / sfh7770 ALS and proximity sensor
  misc: update bhsfh driver to Kconfig and Makefile
  misc: Driver for APDS990X ALS and proximity sensors
  misc: update apds990x driver to Kconfig and Makefile
  Documentation: Short descriptions for bhsfh and apds990x drivers

 Documentation/misc-devices/apds990x.txt |  126 +++
 Documentation/misc-devices/bhsfh.txt    |  125 +++
 drivers/misc/Kconfig                    |   21 +
 drivers/misc/Makefile                   |    2 +
 drivers/misc/apds990x.c                 | 1216 ++++++++++++++++++++++++++++
 drivers/misc/bhsfh.c                    | 1324 +++++++++++++++++++++++++++++++
 include/linux/i2c/apds990x.h            |   57 ++
 include/linux/i2c/bhsfh.h               |   42 +
 8 files changed, 2913 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/apds990x.txt
 create mode 100644 Documentation/misc-devices/bhsfh.txt
 create mode 100644 drivers/misc/apds990x.c
 create mode 100644 drivers/misc/bhsfh.c
 create mode 100644 include/linux/i2c/apds990x.h
 create mode 100644 include/linux/i2c/bhsfh.h

