Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0IMRFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:05:50 -0400
Received: from kroah.org ([198.145.64.141]:46537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0IMRFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:05:49 -0400
Date: Mon, 13 Sep 2010 10:05:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>, Phil Dibowitz <phil@ipom.com>
Subject: Linux 2.6.34.7
Message-ID: <20100913170515.GA8943@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.34.7 kernel.

It fixes a single bug that a number of users have reported in that their
USB devices no longer work properly.  Sometimes it causes lost
keystrokes, and other times X refuses to boot as it can not communicate
properly with some tablet devices.

Many thanks to Jiri Slaby for bisecting the problem down and dealing
with hundreds of angry openSUSE users, and to Alan Stern for figuring
out the root issue.

This really should be the last .34 stable kernel release, unless
something else major like this happens again.

The updated 2.6.34.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.34.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                   |    2 +-
 drivers/usb/core/hub.c     |    6 +-----
 drivers/usb/core/quirks.c  |    3 ---
 include/linux/usb/quirks.h |    4 ----
 4 files changed, 2 insertions(+), 13 deletions(-)

Greg Kroah-Hartman (2):
      Revert "USB delay init quirk for logitech Harmony 700-series devices"
      Linux 2.6.34.7

