Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab1ABXO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 18:14:58 -0500
Received: from imr3.ericy.com ([198.24.6.13]:49829 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab1ABXO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 18:14:56 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.37
Date: Sun, 2 Jan 2011 15:45:26 -0800
Message-ID: <1294011926-6251-1-git-send-email-guenter.roeck@ericsson.com>
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

The following changes since commit 9109f4eb847b7c0be61ae25fb21b1ce2acc9c2d6:

  Merge branch 'kvm-updates/2.6.37' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2011-01-02 10:44:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Maurus Cuelenaere (1):
      hwmon: (s3c-hwmon) Fix compilation

 drivers/hwmon/s3c-hwmon.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
