Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1EWP2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:28:14 -0400
Received: from mail.active-venture.com ([67.228.131.195]:53569 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab1EWP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:28:13 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 May 2011 11:28:12 EDT
X-Originating-IP: 68.125.166.242
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 2.6.40
Date: Mon, 23 May 2011 08:21:32 -0700
Message-Id: <1306164092-13024-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 2.6.40 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Couple of new drivers (ADM1275, MAX16065, MAX6642, UCD9200, UCD90xxx),
merged pkgtemp into coretemp, and added new functionality to the sht15 driver.

Thanks,
Guenter Roeck

------

The following changes since commit 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf:

  Linux 2.6.39 (2011-05-18 21:06:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Durgadoss R (1):
      hwmon: (coretemp) Merge pkgtemp with coretemp

Guenter Roeck (9):
      hwmon: Driver for MAX16065 System Manager and compatibles
      hwmon: (pmbus) Introduce infrastructure to detect sensors and limit registers
      hwmon: (pmbus) Expand scope of device specific get_status function
      hwmon: (pmbus) Use device specific function to read fan configuration
      hwmon: (pmbus) Add support for TI UCD9200 series of PWM System Controllers
      hwmon: (pmbus) Support for TI UCD90xxx series Sequencer and System Health Controllers
      hwmon: (pmbus) Add support for Analog Devices ADM1275
      hwmon: Remove pkgtemp driver
      hwmon: (coretemp) Fix checkpatch errors

Jerome Oufella (1):
      hwmon: (sht15) add support for CRC validation

Per Dalén (1):
      hwmon: Add support for MAX6642

Vivien Didelot (3):
      hwmon: (sht15) general code clean-up
      hwmon: (sht15) clean-up the probe function
      hwmon: (sht15) add support for the status register

 Documentation/hwmon/adm1275  |   60 +++
 Documentation/hwmon/coretemp |   21 +-
 Documentation/hwmon/max16065 |   98 +++++
 Documentation/hwmon/max6642  |   21 +
 Documentation/hwmon/pkgtemp  |   36 --
 Documentation/hwmon/sht15    |   74 ++++
 Documentation/hwmon/ucd9000  |  110 +++++
 Documentation/hwmon/ucd9200  |  112 +++++
 drivers/hwmon/Kconfig        |   66 +++-
 drivers/hwmon/Makefile       |    6 +-
 drivers/hwmon/adm1275.c      |  121 ++++++
 drivers/hwmon/coretemp.c     |  722 +++++++++++++++++++++----------
 drivers/hwmon/max16065.c     |  717 +++++++++++++++++++++++++++++++
 drivers/hwmon/max34440.c     |    6 +-
 drivers/hwmon/max6642.c      |  356 ++++++++++++++++
 drivers/hwmon/max8688.c      |    4 +-
 drivers/hwmon/pkgtemp.c      |  444 -------------------
 drivers/hwmon/pmbus.h        |   10 +-
 drivers/hwmon/pmbus_core.c   |  970 +++++++++++++++++++-----------------------
 drivers/hwmon/sht15.c        |  747 +++++++++++++++++++++++++--------
 drivers/hwmon/ucd9000.c      |  278 ++++++++++++
 drivers/hwmon/ucd9200.c      |  210 +++++++++
 include/linux/sht15.h        |   18 +-
 23 files changed, 3765 insertions(+), 1442 deletions(-)
 create mode 100644 Documentation/hwmon/adm1275
 create mode 100644 Documentation/hwmon/max16065
 create mode 100644 Documentation/hwmon/max6642
 delete mode 100644 Documentation/hwmon/pkgtemp
 create mode 100644 Documentation/hwmon/sht15
 create mode 100644 Documentation/hwmon/ucd9000
 create mode 100644 Documentation/hwmon/ucd9200
 create mode 100644 drivers/hwmon/adm1275.c
 create mode 100644 drivers/hwmon/max16065.c
 create mode 100644 drivers/hwmon/max6642.c
 delete mode 100644 drivers/hwmon/pkgtemp.c
 create mode 100644 drivers/hwmon/ucd9000.c
 create mode 100644 drivers/hwmon/ucd9200.c
