Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab1HMSWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 14:22:06 -0400
Received: from imr4.ericy.com ([198.24.6.9]:37458 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1HMSWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 14:22:03 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.1-rc2
Date: Sat, 13 Aug 2011 11:20:23 -0700
Message-ID: <1313259623-7816-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.1-rc2 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (2):
      hwmon: (pmbus) Virtualize pmbus_write_byte
      hwmon: (pmbus/lm25066) Ignore byte writes to non-zero pages

Julia Lawall (1):
      hwmon: (ibmaem) add missing kfree

 drivers/hwmon/ibmaem.c           |   15 ++++++++++-----
 drivers/hwmon/pmbus/lm25066.c    |   12 ++++++++++++
 drivers/hwmon/pmbus/pmbus.h      |    1 +
 drivers/hwmon/pmbus/pmbus_core.c |   20 +++++++++++++++++++-
 4 files changed, 42 insertions(+), 6 deletions(-)
