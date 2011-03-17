Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1CQXW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:22:27 -0400
Received: from kroah.org ([198.145.64.141]:52878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab1CQXWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:22:23 -0400
Date: Thu, 17 Mar 2011 16:22:19 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 002 release
Message-ID: <20110317232219.GA14382@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 002 release of usbutils.

Nothing major, just a few fixes from the 001 release, and an updated
version of the lsusb.py script from Kurt Garloff.

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

Diego Elio Pettenò (2):
      Simplify the configure script.
      Print device class descriptors like it's done for interface descriptors.

Greg Kroah-Hartman (3):
      Updated version of lsusb.py from Kurt Garloff.
      add lsusb.py to the bin files
      Merge branch 'Flameeyes-master'

