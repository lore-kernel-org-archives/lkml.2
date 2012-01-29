Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2A2UgD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 15:36:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55163 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab2A2UgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 15:36:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fix for 3.3-rc2
Date: Sun, 29 Jan 2012 21:39:39 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201292139.39329.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a hibernate (s2disk) regression fix for 3.3 based on commit
0a9626575400879d1d5e6bc8768188b938d7c501:

  Merge tag 'driver-core-3.3-rc1-bugfixes' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core

as commit 181e9bdef37bfcaa41f3ab6c948a2a0d60a268b5:

  PM / Hibernate: Fix s2disk regression related to freezing workqueues

from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-fix-for-3.3-rc2

This fixes a regression introduced during the 3.2 merge window causing s2disk
to trigger BUG_ON() in freeze_workqueues_begin() if there's not enough swap
space to save the image.

Thanks!


 include/linux/freezer.h |    2 ++
 kernel/power/process.c  |   19 +++++++++++++++++++
 kernel/power/user.c     |    9 +++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)

---------------

Rafael J. Wysocki (1):
      PM / Hibernate: Fix s2disk regression related to freezing workqueues

