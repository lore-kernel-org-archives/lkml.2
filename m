Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab1E0Jw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:52:27 -0400
Received: from imr3.ericy.com ([198.24.6.13]:42975 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1E0Jw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:52:26 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.40
Date: Fri, 27 May 2011 02:51:29 -0700
Message-ID: <1306489889-20741-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.40 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit dc7acbb2518f250050179c8581a972df3b6a24f1:

  Merge branch 'upstream/tidy-xen-mmu-2.6.39' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen (2011-05-26 19:01:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (2):
      hwmon: (coretemp) Update comments describing the handling of HT CPUs
      hwmon: (pmbus) Initialize sysfs attributes

Jean Delvare (1):
      hwmon: (coretemp) Fix section mismatch

Sergey Senozhatsky (1):
      hwmon: (coretemp) Initialize sysfs attributes

 drivers/hwmon/coretemp.c   |   16 +++++++++-------
 drivers/hwmon/pmbus_core.c |    1 +
 2 files changed, 10 insertions(+), 7 deletions(-)
