Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab1DUAr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 20:47:28 -0400
Received: from imr4.ericy.com ([198.24.6.8]:49827 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab1DUAr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 20:47:27 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.39
Date: Wed, 20 Apr 2011 18:02:23 -0700
Message-ID: <1303347743-32210-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.39 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit f0e615c3cb72b42191b558c130409335812621d8:

  Linux 2.6.39-rc4 (2011-04-18 21:26:00 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (7):
      hwmon: Add submitting-patches checklist to documentation
      hwmon: (pmbus) Removed unused variable from struct pmbus_data
      hwmon: (smm665) Fix spelling error in driver documentation
      hwmon: (pmbus) Documentation updates
      hwmon: (max8688) Add driver documentation
      hwmon: (max16064) Add driver documentation
      hwmon: (max34440) Add driver documentation

 Documentation/hwmon/max16064           |   62 ++++++++++++++++++
 Documentation/hwmon/max34440           |   79 +++++++++++++++++++++++
 Documentation/hwmon/max8688            |   69 ++++++++++++++++++++
 Documentation/hwmon/pmbus              |   34 +++--------
 Documentation/hwmon/smm665             |    8 +-
 Documentation/hwmon/submitting-patches |  109 ++++++++++++++++++++++++++++++++
 drivers/hwmon/pmbus_core.c             |    1 -
 7 files changed, 331 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/hwmon/max16064
 create mode 100644 Documentation/hwmon/max34440
 create mode 100644 Documentation/hwmon/max8688
 create mode 100644 Documentation/hwmon/submitting-patches
