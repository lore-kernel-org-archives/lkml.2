Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1AZVRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:17:06 -0500
Received: from imr4.ericy.com ([198.24.6.8]:56880 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1AZVRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:17:05 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.38
Date: Wed, 26 Jan 2011 13:52:24 -0800
Message-ID: <1296078744-21895-1-git-send-email-guenter.roeck@ericsson.com>
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

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Henrik Rydberg (1):
      hwmon: (applesmc) Properly initialize lockdep attributes

Kalhan Trisal (1):
      hwmon: (lis3) turn down the no IRQ message

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Override interface detection on Sabertooth X58

 drivers/hwmon/applesmc.c     |    1 +
 drivers/hwmon/asus_atk0110.c |   23 ++++++++++++++++++++++-
 drivers/hwmon/lis3lv02d.c    |    2 +-
 3 files changed, 24 insertions(+), 2 deletions(-)
