Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab2GFUfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:35:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50506 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab2GFUfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:35:51 -0400
Date: Fri, 6 Jul 2012 13:35:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 006 release
Message-ID: <20120706203547.GA28678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 006 release of usbutils.

Some USB 3.0 updates, a new usb.ids file update, and a number of other
fixes and updates for annoying problems that people had reported.  Full
shortlog information is below if people are curious.

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

Aurelien Jarno (1):
      usb-devices(1): fix a typo

Diego Elio Pettenò (1):
      build: add a --disable-usbids option to avoid installing usb.ids

Greg Kroah-Hartman (8):
      update usbhid-dump to 1.3
      Merge branch 'master' of github.com:gregkh/usbutils
      Merge pull request #8 from Flameeyes/master
      Merge pull request #7 from veltzer/master
      Merge pull request #10 from rogerable/master
      lsusb.c: remove unused variables and the unused -x command line option
      Make 'lsusb -t' use the correct device class string names
      Update usb.ids file with latest version.

Lukas Nykryn (7):
      Possible buffer overflow when using SYSFS_STR
      Reading 26 item in array with size 12.
      Using uninitialized value as index
      Possible resource leak
      Wrong shifting of bmMPEGFeatures byte
      Buffer overun
      lsusb-t: don't show error when driver link is missing

Mark Veltzer (1):
      --tree, --help, and better build documentation

Nikolai Kondrashov (1):
      Update usbhid-dump to complete 1.3 release

Roger Tseng (1):
      Option -V(version) doesn't require an argument.

Sarah Sharp (3):
      usbutils: Dump BOS descriptor for USB 2.01 devices.
      lsusb: Show USB 3.0 U1, U2, and LTM status.
      lsusb: Fix LTM capabilities reporting.

Thierry Vignaud (3):
      set arrays to NULL when freeing them.
      simplify get_string()
      make treedump() work if the database isn't there.

