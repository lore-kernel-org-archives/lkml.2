Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0HTUnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:43:16 -0400
Received: from kroah.org ([198.145.64.141]:42494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab0HTUnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:43:14 -0400
Date: Fri, 20 Aug 2010 13:43:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.52
Message-ID: <20100820204324.GA14579@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.52 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile            |    2 +-
 arch/x86/mm/fault.c |    9 ++++++++-
 fs/proc/task_mmu.c  |    8 +++++++-
 mm/memory.c         |   26 +++++++++++++++++++++++++-
 mm/mmap.c           |    2 +-
 5 files changed, 42 insertions(+), 5 deletions(-)

Greg Kroah-Hartman (2):
      x86: don't send SIGBUS for kernel page faults
      Linux 2.6.27.52

Hugh Dickins (1):
      mm: pass correct mm when growing stack

Linus Torvalds (4):
      mm: keep a guard page below a grow-down stack segment
      mm: fix missing page table unmap for stack guard page failure case
      mm: fix page table unmap for stack guard page properly
      mm: fix up some user-visible effects of the stack guard page

