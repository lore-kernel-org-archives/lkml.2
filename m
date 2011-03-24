Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab1CXPRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:17:14 -0400
Received: from kroah.org ([198.145.64.141]:51214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab1CXPRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:17:13 -0400
Date: Thu, 24 Mar 2011 08:16:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 2.6.32.35
Message-ID: <20110324151649.GA635@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.35 kernel.

It fixes a build error in the 2.6.32.34 kernel.  If you were not hitting
this error, then there is no need to upgrade.

Many thanks to Jiri Slaby for pointing this issue out to me.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile            |    2 +-
 kernel/perf_event.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

Greg Kroah-Hartman (2):
      Revert "perf: Handle stopped state with tracepoints"
      Linux 2.6.32.35

