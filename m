Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab1GKTkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:40:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46643 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541Ab1GKTkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:40:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management regression fix for 3.0
Date: Mon, 11 Jul 2011 21:41:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Colin Cross <ccross@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107112141.14585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a power management regression fix for 3.0 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

It fixes a regression introduced by the recent removal of sysdev_suspend().


 drivers/base/syscore.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

---------------

Colin Cross (1):
      PM: Reintroduce dropped call to check_wakeup_irqs
