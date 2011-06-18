Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1FRP3C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:29:02 -0400
Received: from imr4.ericy.com ([198.24.6.8]:42338 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab1FRP3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:29:00 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.0
Date: Sat, 18 Jun 2011 08:24:46 -0700
Message-ID: <1308410686-21334-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.0 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 95d17b7168eacf1f97f2d1d087ebe7a648c30051:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-06-17 10:37:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (4):
      hwmon: (asus_atk0110) Consolidate sysfs attribute initialization
      hwmon: (ibmaem) Initialize sysfs attributes
      hwmon: (ibmpex) Initialize sysfs attributes
      hwmon: (s3c) Initialize sysfs attributes

Jean Delvare (1):
      hwmon: (coretemp) Drop unused struct members

 drivers/hwmon/asus_atk0110.c |    5 +----
 drivers/hwmon/coretemp.c     |    4 ----
 drivers/hwmon/ibmaem.c       |    2 ++
 drivers/hwmon/ibmpex.c       |    1 +
 drivers/hwmon/s3c-hwmon.c    |    2 ++
 5 files changed, 6 insertions(+), 8 deletions(-)
