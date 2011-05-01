Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1EAUe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 16:34:29 -0400
Received: from imr4.ericy.com ([198.24.6.8]:38425 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab1EAUe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 16:34:27 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.39
Date: Sun, 1 May 2011 13:52:40 -0700
Message-ID: <1304283160-22587-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.39 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 1be6a1f89f131e9c3d22f819ec542be9cda8c9e3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6 (2011-04-29 16:27:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Axel Lin (1):
      hwmon: (twl4030-madc-hwmon) Return proper error if hwmon_device_register fails

 drivers/hwmon/twl4030-madc-hwmon.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)
