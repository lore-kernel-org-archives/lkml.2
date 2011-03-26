Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1CZTyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 15:54:16 -0400
Received: from imr4.ericy.com ([198.24.6.8]:45602 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab1CZTyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 15:54:15 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.39
Date: Sat, 26 Mar 2011 13:01:54 -0700
Message-ID: <1301169714-25636-1-git-send-email-guenter.roeck@ericsson.com>
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

The following changes since commit 16c29dafcc86024048f1dbb8349d31cb22c7c55a:

  Merge branch 'syscore' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6 (2011-03-25 21:07:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Guenter Roeck (1):
      hwmon: (pmbus) Fix temperature limit register access

 drivers/hwmon/pmbus_core.c |   70 ++++++++++++++++++++++---------------------
 1 files changed, 36 insertions(+), 34 deletions(-)
