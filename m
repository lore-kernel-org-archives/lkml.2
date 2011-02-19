Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1BSUvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 15:51:46 -0500
Received: from imr4.ericy.com ([198.24.6.8]:43831 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab1BSUvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 15:51:45 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 2.6.38
Date: Sat, 19 Feb 2011 12:50:29 -0800
Message-ID: <1298148629-1817-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.38 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Besides the bug fixes, there is added support for AMD Family 12h/14h CPUs and
for EMC6D103. I included those because they meet requirements for submission
to stable (new device IDs).

Thanks,
Guenter Roeck

------

The following changes since commit 85e2efbb1db9a18d218006706d6e4fbeb0216213:

  Linux 2.6.38-rc5 (2011-02-15 19:23:45 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git hwmon-for-linus

Clemens Ladisch (4):
      hwmon: (jc42) fix type mismatch
      hwmon: (jc42) more helpful documentation
      hwmon: (jc42) do not allow writing to locked registers
      hwmon: (k10temp) add support for AMD Family 12h/14h CPUs

Guenter Roeck (1):
      MAINTAINERS: Remove stale hwmon quilt tree

Jan Beulich (1):
      hwmon: (lm85) extend to support EMC6D103 chips

 Documentation/hwmon/jc42    |   21 +++++++++++++++------
 Documentation/hwmon/k10temp |    8 +++++++-
 MAINTAINERS                 |    1 -
 drivers/hwmon/Kconfig       |   19 ++++++++++---------
 drivers/hwmon/jc42.c        |   35 ++++++++++++++++++++++++++++++-----
 drivers/hwmon/k10temp.c     |    5 +++--
 drivers/hwmon/lm85.c        |   23 +++++++++++++++++++++--
 7 files changed, 86 insertions(+), 26 deletions(-)
