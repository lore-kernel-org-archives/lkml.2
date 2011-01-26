Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1AZUdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:33:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42366 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab1AZUdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:33:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fix for 2.6.38
Date: Wed, 26 Jan 2011 21:32:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101262132.31890.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull an important power management fix for 2.6.38 (and 2.6.37.y) from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

One of the changes we made in 2.6.37 allowed rpm_suspend() to be called from
interrupt handlers, but forgot to update one code path in there to take that
into account.


 drivers/base/power/runtime.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

---------------

Alan Stern (1):
      PM / Runtime: Don't enable interrupts while running in_interrupt

