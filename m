Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2D2Vfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 17:35:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44582 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab2D2Vfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 17:35:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 3.5-rc5
Date: Sun, 29 Apr 2012 23:40:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bojan Smojver <bojan@rexursive.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Marcos Souza <marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204292340.28110.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 3.5-rc5 since commit
66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4

with top-most commit 26e0f90fded422f309deb6169dfbccb204435698

  PM / Freezer / Docs: Update documentation about freezing of tasks

from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.5-rc5

They are a fix for an issue causing hibernation to hang on systems with highmem
(that practically means i386) due to broken memory management (bug introduced
in 3.2, so -stable material) and PM documentation update making the freezer
documentation follow the code again after some recent updates.

Thanks!


 Documentation/power/freezing-of-tasks.txt |   37 +++++++++++++++--------------
 kernel/power/swap.c                       |   28 +++++++++++++++++----
 2 files changed, 41 insertions(+), 24 deletions(-)

---------------

Bojan Smojver (1):
      PM / Hibernate: fix the number of pages used for hibernate/thaw buffering

Marcos Paulo de Souza (1):
      PM / Freezer / Docs: Update documentation about freezing of tasks

