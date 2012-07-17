Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab2GQUKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:10:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44937 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab2GQUKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:10:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Last-minute power management update for 3.5
Date: Tue, 17 Jul 2012 22:15:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207172215.53075.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the late pull request, but the change in question was only proposed
by Michael for the first time a couple of days ago and I agree that it would be
less painful to make it now rather than later.  This only is a rename of one
capability affecting code that's new in v3.5-rc, so no one should be hurt too
much and everyone concerned appears to be fine with this change.

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-post-3.5-rc7

to receive single commit d9914cf66181b8aa0929775f5c6f675c6ebc3eb5

  PM: Rename CAP_EPOLLWAKEUP to CAP_BLOCK_SUSPEND

on top of 84a1caf1453c3d44050bd22db958af4a7f99315c

  Linux 3.5-rc7

This changes the name of CAP_EPOLLWAKEUP to CAP_BLOCK_SUSPEND to
encourage reuse of that capability in related cases.

Thanks!


 fs/eventpoll.c             | 2 +-
 include/linux/capability.h | 6 +++---
 include/linux/eventpoll.h  | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

---------------

Michael Kerrisk (1):
      PM: Rename CAP_EPOLLWAKEUP to CAP_BLOCK_SUSPEND

