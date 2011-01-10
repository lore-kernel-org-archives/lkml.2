Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1AJOjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:39:08 -0500
Received: from imr4.ericy.com ([198.24.6.8]:36360 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab1AJOjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:39:05 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon changes for 2.6.38
Date: Mon, 10 Jan 2011 07:10:46 -0800
Message-ID: <1294672246-6818-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem changes for Linux 2.6.38 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 0c21e3aaf6ae85bee804a325aa29c325209180fd:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus (2011-01-07 17:16:27 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Davide Rizzo (1):
      hwmon: (lm95241) Rewrite to avoid using macros

Edgar Hucek (1):
      hwmon: (applesmc) Add MacBookAir3,1(3,2) support

Guenter Roeck (3):
      hwmon: (applesmc) Fix checkpatch errors and fix value range checks
      hwmon: sysfs ABI updates
      hwmon: Add humidity attribute to sysfs ABI

Henrik Rydberg (9):
      hwmon: (applesmc) Relax the severity of device init failure
      hwmon: (applesmc) Introduce a register lookup table
      hwmon: (applesmc) Dynamic creation of temperature files
      hwmon: (applesmc) Handle new temperature format
      hwmon: (applesmc) Extract all features generically
      hwmon: (applesmc) Dynamic creation of fan files
      hwmon: (applesmc) Simplify feature sysfs handling
      hwmon: (applesmc) Silence driver
      hwmon: (applesmc) Update copyright information

Jan Beulich (1):
      hwmon: (via-cputemp) sync hotplug handling with coretemp/pkgtemp

Joe Perches (27):
      hwmon: (abituguru) Use pr_fmt and pr_<level>
      hwmon: (abituguru3) Use pr_fmt and pr_<level>
      hwmon: (adt7470) Use pr_fmt and pr_<level>
      hwmon: (asb1000) Use pr_fmt and pr_<level>
      hwmon: (asus_atk0110) Use pr_fmt and pr_<level>
      hwmon: (coretemp) Use pr_fmt and pr_<level>
      hwmon: (dme1737) Use pr_fmt and pr_<level>
      hwmon: (f71805f) Use pr_fmt and pr_<level>
      hwmon: (f71882fg) Use pr_fmt and pr_<level>
      hwmon: (hp_accel) Use pr_fmt and pr_<level>
      hwmon: (hwmon-vid) Use pr_fmt and pr_<level>
      hwmon: (core) Use pr_fmt and pr_<level>
      hwmon: (ibmaem) Use pr_fmt and pr_<level>
      hwmon: (lis3lv02d) Use pr_fmt and pr_<level>
      hwmon: (lm70) Use pr_fmt and pr_<level>
      hwmon: (pcf8591) Use pr_fmt and pr_<level>
      hwmon: (pkgtemp) Use pr_fmt and pr_<level>
      hwmon: (sis5595) Use pr_fmt and pr_<level>
      hwmon: (smsc47b397) Use pr_fmt and pr_<level>
      hwmon: (smsc47m1) Use pr_fmt and pr_<level>
      hwmon: (via-cputemp) Use pr_fmt and pr_<level>
      hwmon: (via686a) Use pr_fmt and pr_<level>
      hwmon: (vt1211) Use pr_fmt and pr_<level>
      hwmon: (vt8231) Use pr_fmt and pr_<level>
      hwmon: (w83627ehf) Use pr_fmt and pr_<level>
      hwmon: (w83627hf) Use pr_fmt and pr_<level>
      hwmon: (applesmc) Use pr_fmt and pr_<level>

Roland Stigge (1):
      hwmon: Support for Dallas Semiconductor DS620

Urs Fleisch (1):
      hwmon: driver for Sensirion SHT21 humidity and temperature sensor

 Documentation/hwmon/ds620           |   34 +
 Documentation/hwmon/sht21           |   49 ++
 Documentation/hwmon/sysfs-interface |   49 +-
 drivers/hwmon/Kconfig               |   20 +
 drivers/hwmon/Makefile              |    2 +
 drivers/hwmon/abituguru.c           |   36 +-
 drivers/hwmon/abituguru3.c          |   45 +-
 drivers/hwmon/adt7470.c             |    4 +-
 drivers/hwmon/applesmc.c            | 1632 ++++++++++++-----------------------
 drivers/hwmon/asb100.c              |    9 +-
 drivers/hwmon/asus_atk0110.c        |    7 +-
 drivers/hwmon/coretemp.c            |   11 +-
 drivers/hwmon/dme1737.c             |   12 +-
 drivers/hwmon/ds620.c               |  337 ++++++++
 drivers/hwmon/f71805f.c             |   29 +-
 drivers/hwmon/f71882fg.c            |   23 +-
 drivers/hwmon/hp_accel.c            |   13 +-
 drivers/hwmon/hwmon-vid.c           |   11 +-
 drivers/hwmon/hwmon.c               |    4 +-
 drivers/hwmon/ibmaem.c              |    4 +-
 drivers/hwmon/lis3lv02d.c           |   23 +-
 drivers/hwmon/lm70.c                |    5 +-
 drivers/hwmon/lm95241.c             |  495 +++++------
 drivers/hwmon/pcf8591.c             |    5 +-
 drivers/hwmon/pkgtemp.c             |    7 +-
 drivers/hwmon/sht21.c               |  307 +++++++
 drivers/hwmon/sis5595.c             |   10 +-
 drivers/hwmon/smsc47b397.c          |   13 +-
 drivers/hwmon/smsc47m1.c            |   31 +-
 drivers/hwmon/via-cputemp.c         |   35 +-
 drivers/hwmon/via686a.c             |   10 +-
 drivers/hwmon/vt1211.c              |   30 +-
 drivers/hwmon/vt8231.c              |   10 +-
 drivers/hwmon/w83627ehf.c           |   23 +-
 drivers/hwmon/w83627hf.c            |   17 +-
 include/linux/i2c/ds620.h           |   21 +
 36 files changed, 1827 insertions(+), 1546 deletions(-)
 create mode 100644 Documentation/hwmon/ds620
 create mode 100644 Documentation/hwmon/sht21
 create mode 100644 drivers/hwmon/ds620.c
 create mode 100644 drivers/hwmon/sht21.c
 create mode 100644 include/linux/i2c/ds620.h
