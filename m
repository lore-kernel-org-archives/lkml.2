Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0HRPHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:07:49 -0400
Received: from kroah.org ([198.145.64.141]:47496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab0HRPHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:07:41 -0400
Date: Wed, 18 Aug 2010 08:06:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [0/6] 2.6.27.52 stable review [try 3]
Message-ID: <20100818150615.GA4752@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 3rd try for the 2.6.27.52 kernel release.  It has 3 more
patches than the -rc1 release, and two more than -rc2.  I've tested this
on my machine, but I'm still getting some kernel log warnings from some
programs.  Any VM developer who wishes to verify that I actually got my
backports correctly would be greatly appreciated as I am not that
comfortable with them.

As an example, look at patch 6/6, I could only figure out the /proc file
change, not the mlock range change, as the VM has changed a lot from .27
to today.  Any help in porting commit
d7824370e26325c881b665350ce64fb0a4fde24a to the .27 tree "properly"
would be greatly appreciated.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.52-rc3.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile            |    2 +-
 arch/x86/mm/fault.c |    9 ++++++++-
 fs/proc/task_mmu.c  |    8 +++++++-
 mm/memory.c         |   26 +++++++++++++++++++++++++-
 mm/mmap.c           |    2 +-
 5 files changed, 42 insertions(+), 5 deletions(-)
