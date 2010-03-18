Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0CRBva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 21:51:30 -0400
Received: from kroah.org ([198.145.64.141]:46473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab0CRBv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 21:51:28 -0400
Date: Wed, 17 Mar 2010 18:51:09 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 0.87 release
Message-ID: <20100318015109.GB28263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 0.87 release of usbutils.

There are some fixes for people having problems with the latest libusb
version, minor code edits, and some new USB class logic.  The whole
changelog is below.

The package can be downladed from kernel.org:
	http://www.kernel.org/pub/linux/utils/usb/usbutils/

We've switched over to using git for development now, which makes things
much easier than the old cvs tree.  The tree can be found on both
kernel.org and github.com if you want to fork it and send us changes
easier:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
	http://github.com/gregkh/usbutils/tree/master

thanks,

greg k-h

-----------

Shortlog of changes since last release (0.86):

Aurelien Jarno (1):
      lsusb.c: correctly dump ccid devices

Greg Kroah-Hartman (11):
      lots of trailing whitespace removed.
      add autogen.sh script
      coding style cleanups for .h files.
      names.c: fix up some compiler warnings
      coding style cleanups for usbmisc.c
      names.c: fix lots of coding style issues
      devtree.c: coding style cleanups
      lsusb.c: coding style fixes
      lsusb.c: fix some build warnings.
      usb.ids: Reserve EEM Gadget id for the Linux Foundation
      add lsusb.py from Kurt Garloff <garloff@suse.de>

Philip A. Prindeville (1):
      Fix build issue with libusb location


