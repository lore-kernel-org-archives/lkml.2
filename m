Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab1E0VZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 17:25:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35546 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab1E0VZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 17:25:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Hibernate and PM QoS updates for 2.6.40
Date: Fri, 27 May 2011 23:25:40 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105272325.40859.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull more power management updates for 2.6.40 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They are three hibernate patches that fix comments and remove an unused
architecture hook and a PM QoS fix that didn't make it into my first request.


 arch/frv/include/asm/suspend.h       |   20 ---
 arch/mips/include/asm/suspend.h      |    2 -
 arch/powerpc/include/asm/suspend.h   |    6 -
 arch/powerpc/kernel/swsusp.c         |    1 -
 arch/s390/include/asm/suspend.h      |   10 --
 arch/sh/include/asm/suspend.h        |    1 -
 arch/unicore32/include/asm/suspend.h |    1 -
 arch/x86/include/asm/suspend_32.h    |    2 -
 arch/x86/include/asm/suspend_64.h    |    5 -
 kernel/pm_qos_params.c               |   33 ++++--
 kernel/power/hibernate.c             |  220 +++++++++++++++++-----------------
 11 files changed, 134 insertions(+), 167 deletions(-)

---------------

Rafael J. Wysocki (4):
      PM / Hibernate: Update some comments in core hibernate code
      PM / Hibernate: Remove arch_prepare_suspend()
      PM / Hibernate: Update kerneldoc comments in hibernate.c
      PM: Fix PM QOS's user mode interface to work with ASCII input

