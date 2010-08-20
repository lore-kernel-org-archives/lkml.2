Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0HTUrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:47:42 -0400
Received: from kroah.org ([198.145.64.141]:46814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab0HTUrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:47:39 -0400
Date: Fri, 20 Aug 2010 13:47:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.34.5
Message-ID: <20100820204753.GE14579@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.34.5 kernel.

All users of the 2.6.34 kernel series must upgrade.  Actually, you
should switch to the .35 kernel releases, as there is only going to be
one more .34-stable kernel release after this one.  Really, I mean it
this time :)

The updated 2.6.34.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.34.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                     |    2 +-
 arch/x86/kernel/cpu/vmware.c |    1 +
 fs/proc/task_mmu.c           |    8 +++++++-
 mm/memory.c                  |   13 ++++++-------
 mm/mlock.c                   |    8 ++++++++
 5 files changed, 23 insertions(+), 9 deletions(-)

Greg Kroah-Hartman (2):
      vmware: fix build error in vmware.c
      Linux 2.6.34.5

Linus Torvalds (2):
      mm: fix page table unmap for stack guard page properly
      mm: fix up some user-visible effects of the stack guard page

