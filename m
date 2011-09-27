Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1I0Vk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:40:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60027 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1I0Vk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:40:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management regression fix for 3.1
Date: Tue, 27 Sep 2011 23:42:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109272342.38454.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull one power management regression fix for 3.1 on top of commit
f9d81f61c84aca693bc353dfef4b8c36c2e5e1b5 (ptrace: PTRACE_LISTEN forgets to
unlock ->siglock) from

git://github.com/rjwysocki/linux-pm.git pm-fixes

It fixes a locking bug introduced by one of the previous PM commits,
as described in the changelog.

Thanks!


 drivers/base/power/clock_ops.c |   75 ++++++++++++++++++++-------------------
 1 files changed, 38 insertions(+), 37 deletions(-)

---------------

Rafael J. Wysocki (1):
      PM / Clocks: Do not acquire a mutex under a spinlock

