Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1GJQbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:31:31 -0400
Received: from imr4.ericy.com ([198.24.6.8]:49897 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab1GJQb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:31:28 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.0
Date: Sun, 10 Jul 2011 09:30:36 -0700
Message-ID: <1310315436-28204-1-git-send-email-guenter.roeck@ericsson.com>
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

The following changes since commit fe0d42203cb5616eeff68b14576a0f7e2dd56625:

  Linux 3.0-rc6 (2011-07-04 15:56:24 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (3):
      hwmon: (lm95241) Fix chip detection code
      hwmon: (lm95241) Fix negative temperature results
      hwmon: (pmbus) Improve auto-detection of temperature status register

 drivers/hwmon/lm95241.c |   22 +++++++++++++++-------
 drivers/hwmon/pmbus.c   |   11 ++++++-----
 2 files changed, 21 insertions(+), 12 deletions(-)
