Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab1CMTae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 15:30:34 -0400
Received: from imr4.ericy.com ([198.24.6.8]:38598 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab1CMTad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 15:30:33 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.38
Date: Sun, 13 Mar 2011 12:34:47 -0700
Message-ID: <1300044887-30680-1-git-send-email-guenter.roeck@ericsson.com>
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

The following changes since commit a5abba989deceb731047425812d268daf7536575:

  Linux 2.6.38-rc8 (2011-03-07 21:09:37 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Hans de Goede (2):
      hwmon/f71882fg: Fix a typo in a comment
      hwmon/f71882fg: Set platform drvdata to NULL later

 drivers/hwmon/f71882fg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
