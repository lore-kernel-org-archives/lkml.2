Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab1CCREK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:04:10 -0500
Received: from kroah.org ([198.145.64.141]:56193 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab1CCREJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:04:09 -0500
Date: Thu, 3 Mar 2011 09:03:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.31
Message-ID: <20110303170339.GA3995@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.31 kernel.

All users of the 2.6.32 kernel series must upgrade.

It only contains one patch, a revert of a patch that broke the build on
a number of systems and should have never been included in the .32 tree.
This was my fault, I had it reverted in my local development machine,
but forgot to sync it up to my laptop which I took with me this week
while traveling to a Linux Foundation conference, where I did the final
release.

Sorry for any problems this might have caused.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile      |    2 +-
 lib/swiotlb.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

Greg Kroah-Hartman (2):
      Revert "swiotlb: fix wrong panic"
      Linux 2.6.32.31

