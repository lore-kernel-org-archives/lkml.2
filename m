Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0KXRnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:43:51 -0500
Received: from imr4.ericy.com ([198.24.6.8]:46879 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0KXRnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:43:50 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.37-rc4
Date: Wed, 24 Nov 2010 10:04:31 -0800
Message-ID: <1290621871-27576-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.37-rc4 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 3561d43fd289f590fdae672e5eb831b8d5cf0bf6:

  Linux 2.6.37-rc3 (2010-11-21 15:18:56 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (2):
      hwmon: (i5k_amb) Fix compile warning
      hwmon: (lis3lv02d_i2c) Fix compile warnings

 drivers/hwmon/i5k_amb.c       |    2 ++
 drivers/hwmon/lis3lv02d_i2c.c |   10 ++++------
 2 files changed, 6 insertions(+), 6 deletions(-)
