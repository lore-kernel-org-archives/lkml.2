Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1K2Wjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:39:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1K2Wjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:39:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Hibernate fix and PM documentation updates for 3.2
Date: Tue, 29 Nov 2011 23:42:32 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111292342.32576.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a hibernate fix and power management documentation updates (on top
of commit f10cdea68b70bd85706baed0decab59618f9c353) for 3.2 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-fixes

with top-most commit f7bc83d87d242917ca0ee041ed509f57f361dd56
(PM: Update comments describing device power management callbacks).

The hibernate fix closes a massive memory leak from error and test code paths
(which happens if hibernation is aborted early enough) and the documentation
updates modify the documentation to follow the code again after some recent
changes.

Thanks!


 Documentation/power/devices.txt    |  111 +++++++++++-------
 Documentation/power/runtime_pm.txt |   40 ++++---
 include/linux/pm.h                 |  229 +++++++++++++++++++++---------------
 kernel/power/hibernate.c           |   16 ++-
 4 files changed, 237 insertions(+), 159 deletions(-)

---------------

Rafael J. Wysocki (6):
      PM / Hibernate: Do not leak memory in error/test code paths
      PM / Domains: Document how PM domains are used by the PM core
      PM / Sleep: Correct inaccurate information in devices.txt
      PM / Runtime: Make documentation follow the new behavior of irq_safe
      PM / Sleep: Update documentation related to system wakeup
      PM: Update comments describing device power management callbacks

