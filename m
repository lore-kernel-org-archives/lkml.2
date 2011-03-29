Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1C2PBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:01:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55109 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1C2PBg (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 29 Mar 2011 11:01:36 -0400
Date: Tue, 29 Mar 2011 11:00:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        randy.dunlap@oracle.com, error27@gmail.com, dgdegra@tycho.nsa.gov
Subject: [GIT PULL] (xen) bug fixes for 2.6.39 .. rc1-soonish?
 (stable/bug-fixes-rc1).
Message-ID: <20110329150030.GA7368@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D91F40D.0093,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull this branch:

	git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-rc1

which has patches since the git commit 804f18536984939622ddca60ab6b25743e0ec68d:

Linus Torvalds (1):

    Merge branch 'stable/xen.pm.bug-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen

The fixes include cleanups done by Thomas, and as well some fixes on the
exit patchs found in the gntdev by Dan Carpenter. Compile warnings and one
serious bug that causes the machine to oops when using the gntdev,gntalloc along
with memory hotplug. Sorry about the name of the branch - I was thinking that ther
c1 would be out by now.


Dan Carpenter (2):
      xen-gntdev: return -EFAULT on copy_to_user failure
      xen-gntdev: unlock on error path in gntdev_mmap()

Daniel De Graaf (1):
      xen/p2m: Allocate p2m tracking pages on override

Randy Dunlap (1):
      xen: fix p2m section mismatches

Thomas Gleixner (2):
      xen: Convert genirq namespace
      xen: Use new irq_move functions

 arch/x86/xen/p2m.c   |   10 ++++++----
 drivers/xen/events.c |   26 +++++++++++++-------------
 drivers/xen/gntdev.c |    6 ++++--
 3 files changed, 23 insertions(+), 19 deletions(-)
