Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab1BKGLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 01:11:22 -0500
Received: from imr4.ericy.com ([198.24.6.8]:58888 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab1BKGLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 01:11:21 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.38
Date: Thu, 10 Feb 2011 22:10:33 -0800
Message-ID: <1297404633-19309-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.38 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:

  Linux 2.6.38-rc4 (2011-02-07 16:03:55 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Dirk Eibach (1):
      hwmon: (lm63) Consider LM64 temperature offset

Guenter Roeck (1):
      hwmon: (emc1403) Fix I2C address range

 drivers/hwmon/emc1403.c |    2 +-
 drivers/hwmon/lm63.c    |   59 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 13 deletions(-)
