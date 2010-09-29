Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0I2BNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:13:32 -0400
Received: from kroah.org ([198.145.64.141]:53915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0I2BNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:13:31 -0400
Date: Tue, 28 Sep 2010 18:13:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.35.7
Message-ID: <20100929011355.GA25515@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.35.7 kernel.
This is only needed if you run Xen, there was a typo that caused
problems.  My fault, sorry.

Greetings from LinuxCon 2010, Tokyo.  You should have been here.

The updated 2.6.35.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

thanks,

greg k-h

------------


 Makefile             |    4 ++--
 drivers/xen/events.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


Greg Kroah-Hartman (1):
      Linux 2.6.35.7

James Dingwall (1):
      Xen: fix typo in previous patch

