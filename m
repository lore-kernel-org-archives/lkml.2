Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab0JSHKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:10:25 -0400
Received: from smtp.nokia.com ([147.243.1.47]:25451 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab0JSHKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:10:24 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: akpm@linux-foundation.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv4 0/5] BH1770GLC, SFH7770 and APDS990x als / proximity sensor drivers
Date: Tue, 19 Oct 2010 10:09:43 +0300
Message-Id: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
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

Changes since patch set version 3:

- acked-by added to patches 1, 3 and 5
- Documentation clean up (extra lines removed, LUX changed to lux)

Patches 2 and 4 are not directly acked or I have missed something.
However, all requested cleanups have been done to those patches.

Tested on top of 2.6.36-rc5

Samu Onkalo (5):
  misc: Driver for bh1770glc / sfh7770 ALS and proximity sensor
  misc: update bh1770glc driver to Kconfig and Makefile
  misc: Driver for APDS990X ALS and proximity sensors
  misc: update apds990x driver to Kconfig and Makefile
  Documentation: Short descriptions for bh1770glc and apds990x drivers

 Documentation/misc-devices/apds990x.txt  |  111 +++
 Documentation/misc-devices/bh1770glc.txt |  116 +++
 drivers/misc/Kconfig                     |   21 +
 drivers/misc/Makefile                    |    2 +
 drivers/misc/apds990x.c                  | 1295 +++++++++++++++++++++++++++
 drivers/misc/bh1770glc.c                 | 1413 ++++++++++++++++++++++++++++++
 include/linux/i2c/apds990x.h             |   79 ++
 include/linux/i2c/bh1770glc.h            |   53 ++
 8 files changed, 3090 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/apds990x.txt
 create mode 100644 Documentation/misc-devices/bh1770glc.txt
 create mode 100644 drivers/misc/apds990x.c
 create mode 100644 drivers/misc/bh1770glc.c
 create mode 100644 include/linux/i2c/apds990x.h
 create mode 100644 include/linux/i2c/bh1770glc.h

