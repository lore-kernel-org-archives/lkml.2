Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1GCUUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 16:20:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab1GCUUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 16:20:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management documentation fixes for 3.0
Date: Sun, 3 Jul 2011 22:20:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107032220.56409.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management documentation fixes for 3.0 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

One of them makes documentation match the code again after a recent change
and it depends on the other one, which fixes a typo.


 Documentation/power/runtime_pm.txt |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

---------------

Kevin Hilman (1):
      PM: Documentation: fix typo: pm_runtime_idle_sync() doesn't exist.

Rafael J. Wysocki (1):
      PM / Runtime: Update documentation regarding driver removal

