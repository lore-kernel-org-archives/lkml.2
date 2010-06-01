Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0FARB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:01:28 -0400
Received: from kroah.org ([198.145.64.141]:51120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab0FARB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:01:26 -0400
Date: Tue, 1 Jun 2010 10:00:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.15
Message-ID: <20100601170032.GA23431@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.15 kernel.

It reverts two patches that were previously applied that shouldn't have
been in the .32 kernel series.  If you don't have any problems with the
2.6.34.14 kernel, there's no need to upgrade to this release.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile         |    2 +-
 kernel/lockdep.c |    6 +++---
 kernel/module.c  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

Greg Kroah-Hartman (3):
      Revert "lockdep: fix incorrect percpu usage"
      Revert "modules: fix incorrect percpu usage"
      Linux 2.6.32.15

