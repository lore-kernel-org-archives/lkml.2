Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0IYBVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 21:21:11 -0400
Received: from imr4.ericy.com ([198.24.6.8]:39423 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0IYBVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 21:21:10 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.36
Date: Fri, 24 Sep 2010 18:28:01 -0700
Message-ID: <1285378081-7902-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.36 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

Guenter Roeck (1):
      MAINTAINERS: Update hwmon entry

Jan Beulich (7):
      x86/hwmon: fix module init for hotplug-but-no-device-found case
      x86/hwmon: avoid deadlock on CPU removal in pkgtemp
      x86/hwmon: don't leak device attribute file from pkgtemp_probe() and pkgtemp_remove()
      x86/hwmon: fix initialization of coretemp
      x86/hwmon: fix initialization of pkgtemp
      x86/hwmon: register alternate sibling upon CPU removal
      x86/hwmon: pkgtemp has no dependency on PCI

Takashi Iwai (1):
      hwmon: (lis3) Fix Oops with NULL platform data

 MAINTAINERS                       |    2 +
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/scattered.c   |    1 +
 drivers/hwmon/Kconfig             |    2 +-
 drivers/hwmon/coretemp.c          |   56 +++++++++++++++++++++----------------
 drivers/hwmon/lis3lv02d.c         |    4 +-
 drivers/hwmon/pkgtemp.c           |   23 +++++++--------
 7 files changed, 50 insertions(+), 39 deletions(-)
