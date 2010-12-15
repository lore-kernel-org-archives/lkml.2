Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304Ab0LOAtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:49:41 -0500
Received: from kroah.org ([198.145.64.141]:41968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760291Ab0LOAtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:49:39 -0500
Date: Tue, 14 Dec 2010 16:49:32 -0800
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 001 release
Message-ID: <20101215004932.GA15852@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 001 release of usbutils.

Yes, it's a new numbering scheme, to show some major changes.  Namely
usbutils is finally using the libusb 1.0 library, enabling distros to
hopefully dump the old libusb-compat library entirely now.

Many thanks to Mike Frysinger for doing the libusb conversion work, and
to the other contributors listed below for new features and bugfixes.

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

Greg Kroah-Hartman (2):
      usb.ids update from linux-usb.org
      updated usbhid-dump subproject

Laurent Pinchart (2):
      usbutils: Support UVC frame-based descriptors
      usbutils: Support UVC MPEG2-TS format descriptor

Luben Tuikov (3):
      lsusb: Fix getting BOS and DEVQUAL descriptors
      lsusb: Dump the Pipe Usage desciptor
      lsusb: Fix bMaxBurst reporting

Mike Frysinger (5):
      lsusb: install into /usr/bin
      usbmisc: pull in unistd.h for readlink()
      lsusb: pull in stdlib.h for exit()
      lsusb: constify!
      usbutils: convert to libusb-1.0

Nikolai Kondrashov (1):
      Update usbhid-dump to release 1.2

Sarah Sharp (2):
      usbutils: Fix compile error on Ubuntu 9.04.
      usbutils: Make lsusb -t show USB 3.0 devices.

