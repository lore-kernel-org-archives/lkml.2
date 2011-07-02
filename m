Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1GBVxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:53:20 -0400
Received: from imr3.ericy.com ([198.24.6.13]:53266 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1GBVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:53:18 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.0
Date: Sat, 2 Jul 2011 14:52:32 -0700
Message-ID: <1309643552-17775-1-git-send-email-guenter.roeck@ericsson.com>
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

The following changes since commit daf54f1f363a61c618662ef66d4bf09d2b090941:

  drm/radeon/kms: Fix chremap setup on RV770 CE (2011-07-01 07:29:46 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (4):
      hwmon: (pmbus) Drop check for PMBus revision register in probe function
      hwmon: (adm1275) Free allocated memory if probe function fails
      hwmon: (pmbus) Improve fan detection
      hwmon: (pmbus) Auto-detect temp2 and temp3 registers/attributes

 drivers/hwmon/adm1275.c    |   16 +++++++++++++---
 drivers/hwmon/pmbus.c      |   10 ++++++++--
 drivers/hwmon/pmbus_core.c |   11 +++--------
 3 files changed, 24 insertions(+), 13 deletions(-)
