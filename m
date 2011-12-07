Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab1LGV6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:58:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758511Ab1LGV6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:58:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Shutdown regression fix related to PM for 3.2
Date: Wed, 7 Dec 2011 23:01:11 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, NeilBrown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112072301.11583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a shutdown regression fix related to power management (on top
of commit b835c0f47f725d864bf2545f10c733b754bb6d51) for 3.2 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-fixes

with commit hash fe6b91f47080eb17d21cbf2a39311877d57f6938
(PM / Driver core: leave runtime PM enabled during system shutdown).

It fixes an issue with some drivers that stopped handling shutdown
correctly because of a recent commit that disabled runtime PM during
shutdown.

Thanks!


 drivers/base/core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

---------------

Alan Stern (1):
      PM / Driver core: leave runtime PM enabled during system shutdown

