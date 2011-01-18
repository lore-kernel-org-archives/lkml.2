Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1ARVjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:39:35 -0500
Received: from imr3.ericy.com ([198.24.6.13]:59669 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab1ARVje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:39:34 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon changes for 2.6.38
Date: Tue, 18 Jan 2011 14:13:11 -0800
Message-ID: <1295388791-21305-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem changes for Linux 2.6.38 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit a25cecce88194b2edf38b8c3b1665e9318eb2d22:

  Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze (2011-01-18 08:06:22 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (1):
      hwmon: (lm93) Add support for LM94

 Documentation/hwmon/lm93 |    7 +++++++
 drivers/hwmon/Kconfig    |    4 ++--
 drivers/hwmon/lm93.c     |   21 +++++++++++++++++++--
 3 files changed, 28 insertions(+), 4 deletions(-)
