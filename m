Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0LFXsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:48:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59510 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0LFXsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:48:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Hibernate fixes for 2.6.37
Date: Tue, 7 Dec 2010 00:47:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Bojan Smojver <bojan@rexursive.com>, Hugh Dickins <hughd@google.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012070047.45335.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two hibernate fixes for 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

They include:

* Fix for a regression that may lead to post-resume memory corruption and unfortunately
  made it into -stable kernels.

* Fix related to image compression (that will be new in 2.6.37).


 include/linux/gfp.h      |    4 +-
 kernel/power/hibernate.c |   22 ++++++++++--------
 kernel/power/suspend.c   |    5 +--
 kernel/power/swap.c      |   53 +++++++++++++++++++++++++++++++++-------------
 kernel/power/user.c      |    2 +
 mm/page_alloc.c          |   19 ++++++++++------
 6 files changed, 68 insertions(+), 37 deletions(-)

---------------

Bojan Smojver (1):
      PM / Hibernate: Use async I/O when reading compressed hibernation image

Rafael J. Wysocki (1):
      PM / Hibernate: Fix memory corruption related to swap

