Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1HYFoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 01:44:21 -0400
Received: from imr3.ericy.com ([198.24.6.13]:53537 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab1HYFoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 01:44:21 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.1-rc4
Date: Wed, 24 Aug 2011 22:43:06 -0700
Message-ID: <1314250986-27516-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.1-rc4 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c:

  Linux 3.1-rc3 (2011-08-22 11:42:53 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (1):
      hwmon: (ntc_thermistor) Simplify if sequence

Jean Delvare (1):
      hwmon: (i5k_amb) Drop i5k_channel_pci_id

 drivers/hwmon/i5k_amb.c        |   42 +++++++++++++--------------------------
 drivers/hwmon/ntc_thermistor.c |    3 +-
 2 files changed, 15 insertions(+), 30 deletions(-)
