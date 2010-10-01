Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab0JAU5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:57:37 -0400
Received: from kroah.org ([198.145.64.141]:44086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703Ab0JAU5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:57:36 -0400
Date: Fri, 1 Oct 2010 13:57:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.24
Message-ID: <20101001205709.GA11271@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.24 kernel.

This is only needed if you run Xen, there was a typo that caused
problems.  My fault, sorry.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile             |    2 +-
 drivers/xen/events.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (1):
      Linux 2.6.32.24

James Dingwall (1):
      Xen: fix typo in previous patch

