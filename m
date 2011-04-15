Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab1DOVgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:36:18 -0400
Received: from kroah.org ([198.145.64.141]:52267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab1DOVgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:36:14 -0400
Date: Fri, 15 Apr 2011 14:34:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.38
Message-ID: <20110415213458.GC30847@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.38 kernel.

It's a bugfix for the 2.6.32.37 kernel that only affects people who use
the network RDS protocol.  If you don't use that, then don't worry about
this release.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile       |    2 +-
 net/rds/rdma.c |    8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

Greg Kroah-Hartman (2):
      Revert "net: fix rds_iovec page count overflow"
      Linux 2.6.32.38

