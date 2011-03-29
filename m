Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1C2Tys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:54:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53244 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab1C2Tyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:54:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [GIT PULL] Power management Kconfig modification for 2.6.39
Date: Tue, 29 Mar 2011 21:54:59 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
MIME-Version: 1.0
Message-Id: <201103292154.59567.rjw@sisk.pl>
X-Length: 1358
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Forgot to CC the lists and interested people, sorry.]

Hi Linus,

Please pull a power management Kconfig modification for 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

It modifies power management core Kconfig options so that Xen save/restore
can select CONFIG_HIBERNATION without including the whole image creating and
saving code and the hibernate user space interfaces into the kernel.


 arch/x86/power/Makefile |    3 ++-
 include/linux/suspend.h |   15 +++++----------
 kernel/power/Kconfig    |    4 ++++
 kernel/power/Makefile   |    4 ++--
 kernel/power/main.c     |    2 +-
 kernel/power/power.h    |    6 +++---
 6 files changed, 17 insertions(+), 17 deletions(-)

---------------

Rafael J. Wysocki (1):
      PM / Hibernate: Introduce CONFIG_HIBERNATE_INTERFACE

