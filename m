Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab1HLUyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 16:54:52 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54665 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab1HLUyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:54:50 -0400
X-Sasl-enc: O8bjwDjvYg9UoH+koKk2km2He+OsajeWeijSd/2PDyST 1313182489
Date: Fri, 12 Aug 2011 13:53:49 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 004 release
Message-ID: <20110812205349.GA31222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 004 release of usbutils.

This fixes a much reported bug with USB devices that users didn't have
permissions to access, and a few other reported problems as well.

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

Carl-Daniel Hailfinger (2):
      Fix lsusb out-of-bounds write
      Fix lsusb double-free

Dafydd Crosby (2):
      Verbose flag in tree mode shows vendor and product name.     When running `lsusb -tv`, devices should have the vendor and     product name appended to the row.
      Fix compiler warning

Greg Kroah-Hartman (2):
      Merge pull request #2 from nphilipp/master--nphilipp
      Merge pull request #3 from dafyddcrosby/lsusb-tv

Nils Philippsen (1):
      don't use invalid config descriptors

