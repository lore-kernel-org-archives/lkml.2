Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0JVXmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:42:42 -0400
Received: from kroah.org ([198.145.64.141]:42604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab0JVXml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:42:41 -0400
Date: Fri, 22 Oct 2010 16:43:22 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 0.91 release
Message-ID: <20101022234322.GA11147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 0.91 release of usbutils.

Big thing is here is the addition of the usbhid-dump tool from Nikolai
Kondrashov, and a bunch of changes to handle USB 3.0 hubs (hopefully)
properly.  Oh, and the build issues on non-Linux systems should be
resolved now as well.

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

Greg Kroah-Hartman (3):
      add usbhid-dump to the autogen.sh script
      usb.ids: add new device id for qemu audio device
      Minor fixes

Laurent Pinchart (1):
      usbutils: Fix the UVC bmInterlaceFlags field decoding

Mike Frysinger (2):
      usbutils.pc: use datarootdir
      fix building on non-Linux systems (e.g. BSD)

Nikolai Kondrashov (1):
      Integrate usbhid-dump

Sarah Sharp (5):
      usbutils: Fix Wireless USB descriptor fetching.
      usbutils: Support USB 3.0 hub descriptor output.
      usbutils: Print MaxStreams and Mult for USB 3.0 devices.
      usbutils: Print Binary Object Store descriptor.
      usbutils: Fix bug in link state description printing.


