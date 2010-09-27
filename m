Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab0I0AEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:04:09 -0400
Received: from imr4.ericy.com ([198.24.6.8]:33470 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab0I0AEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:04:07 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.36 - take two
Date: Sun, 26 Sep 2010 17:11:57 -0700
Message-ID: <1285546317-18970-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.36 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

This is a single commit which fixes the built breakage introduced with the
series I sent out yesterday. For your convenience, I also copied you on the 
patch itself.

Thanks,
Guenter Roeck

------

Guenter Roeck (1):
      hwmon (coretemp): Fix build breakage if SMP is undefined

 drivers/hwmon/coretemp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
