Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2BDXPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 18:15:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab2BDXPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 18:15:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 3.3-rc3
Date: Sun, 5 Feb 2012 00:19:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202050019.15450.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 3.3-rc3 since commit
62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2

with top-most commit d020283dc694c9ec31b410f522252f7a8397e67d

  PM / QoS: CPU C-state breakage with PM Qos change

from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-fixes-for-3.3-rc3

They include:

* Two hibernate (s2disk) regression fixes from Srivatsa S. Bhat (for
  regressions introduced during the 3.3 merge window and during the 3.2
  development cycle).

* A cpuidle fix from Venki Pallipadi for a regression resulting from PM QoS
  changes during the 3.2 development cycle causing cpuidle to work incorrectly
  for CONFIG_PM unset.

Thanks!


 include/linux/pm_qos.h |   14 +++++++++++++-
 kernel/power/power.h   |   24 ++++++++++++++++++++++--
 kernel/power/process.c |    7 +++++--
 kernel/power/user.c    |    6 ++++--
 4 files changed, 44 insertions(+), 7 deletions(-)

---------------

Srivatsa S. Bhat (2):
      PM / Hibernate: Thaw kernel threads in SNAPSHOT_CREATE_IMAGE ioctl path
      PM / Freezer: Thaw only kernel threads if freezing of kernel threads fails

Venkatesh Pallipadi (1):
      PM / QoS: CPU C-state breakage with PM Qos change

