Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2AWVku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:40:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46610 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab2AWVkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:40:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 3.3
Date: Mon, 23 Jan 2012 22:44:19 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201232244.19379.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 3.3 since commit
90a4c0f51e8e44111a926be6f4c87af3938a79c3:

  uml: fix compile for x86-64 (2012-01-18 19:26:11 -0800)

with top-most commit e4c89a508f4385a0cd8681c2749a2cd2fa476e40

  PM / Sleep: Fix read_unlock_usermodehelper() call.

from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-fixes-for-3.3

(this actually is a signed tag, which I've tried to use for the first time
ever, but hopefully it's OK).

They include a hibernate (s2disk) regression fix related to the freezer,
a freezer-related _request_firmware() error code path fix, a hibernate fix
for an image size computation error and two PM documentation fixes.

Thanks!


 Documentation/power/basic-pm-debugging.txt |    2 +-
 Documentation/power/freezing-of-tasks.txt  |    8 ++++----
 drivers/base/firmware_class.c              |    3 +--
 include/linux/suspend.h                    |   19 +++++++++++++++++--
 kernel/power/snapshot.c                    |    3 ++-
 5 files changed, 25 insertions(+), 10 deletions(-)

---------------

Namhyung Kim (1):
      PM / Hibernate: Correct additional pages number calculation

Srivatsa S. Bhat (1):
      PM / Hibernate: Rewrite unlock_system_sleep() to fix s2disk regression

Tetsuo Handa (1):
      PM / Sleep: Fix read_unlock_usermodehelper() call.

Viresh Kumar (2):
      PM / Documentation: Fix spelling mistake in basic-pm-debugging.txt
      PM / Documentation: Fix minor issue in freezing_of_tasks.txt

