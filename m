Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab1BZRwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 12:52:20 -0500
Received: from imr3.ericy.com ([198.24.6.13]:58034 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab1BZRwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 12:52:15 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.38
Date: Sat, 26 Feb 2011 09:52:13 -0800
Message-ID: <1298742733-9854-1-git-send-email-guenter.roeck@ericsson.com>
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

The following changes since commit 493f3358cb289ccf716c5a14fa5bb52ab75943e5:

  Merge branch 'pm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6 (2011-02-25 15:15:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Axel Lin (2):
      hwmon: (ad7414) add MODULE_DEVICE_TABLE
      hwmon: (adt7411) add MODULE_DEVICE_TABLE

 drivers/hwmon/ad7414.c  |    1 +
 drivers/hwmon/adt7411.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)
