Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0DMXUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:20:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54695 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab0DMXUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:20:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM / hibernate fix for 2.6.34
Date: Wed, 14 Apr 2010 01:23:02 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004140123.03040.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hibernation fix for 2.6.34 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

It makes the hibernate user space interface work when
CONFIG_DEBUG_BLOCK_EXT_DEVT is set.

 kernel/power/user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---------------

Jiri Slaby (1):
      PM / Hibernate: user.c, fix SNAPSHOT_SET_SWAP_AREA handling

