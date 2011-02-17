Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1BQXbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:31:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab1BQXbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:31:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Hibernate fix for 2.6.38
Date: Fri, 18 Feb 2011 00:30:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102180030.55000.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a hibernate fix for 2.6.38 (and stable) from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

It fixes an old bug, but such that it can make a later BUG_ON() trigger, so
it's rather serious.


 kernel/power/snapshot.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

---------------

Stanislaw Gruszka (1):
      PM / Hibernate: Return error code when alloc_image_page() fails

