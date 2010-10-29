Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109Ab0J2V7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:59:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab0J2V7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:59:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] One more power management fix for 2.6.37
Date: Fri, 29 Oct 2010 23:58:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010292358.27975.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull one more power management fix for 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

It fixes a regression in the core I/O runtime PM code.


 drivers/base/power/runtime.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---------------

Kevin Winchester (1):
      PM / Runtime: Fix typo in status comparison causing warning

