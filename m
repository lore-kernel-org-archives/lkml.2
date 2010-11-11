Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0KKRbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:31:46 -0500
Received: from imr4.ericy.com ([198.24.6.8]:44876 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab0KKRbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:31:45 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.37
Date: Thu, 11 Nov 2010 09:50:03 -0800
Message-ID: <1289497803-15160-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.37 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit f6614b7bb405a9b35dd28baea989a749492c46b2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2010-11-09 10:34:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Axel Lin (3):
      hwmon: (adt7470) Return proper error code for adt7470_probe()
      hwmon: (ad7414) Return proper error code for ad7414_probe()
      hwmon: (gpio-fan) Fix fan_ctrl_init error path

 drivers/hwmon/ad7414.c   |    6 ++++--
 drivers/hwmon/adt7470.c  |    4 +++-
 drivers/hwmon/gpio-fan.c |    8 ++++----
 3 files changed, 11 insertions(+), 7 deletions(-)
