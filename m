Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1JVQXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 12:23:48 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:47449 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764Ab1JVQXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 12:23:46 -0400
X-Sasl-enc: TbkOxwrwWrT6M78bHZBvQ0KrGmH/fxRGjLPBmgFF89cj 1319300625
Date: Sat, 22 Oct 2011 18:23:26 +0200
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 005 release
Message-ID: <20111022162326.GA749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 004 release of usbutils.

Some USB 3.0 bugfixes, and a new usb.ids file update.  Nothing major.

With kernel.org file upload still not fully working, please use the
github link below to get a tarball if you need/want it.

We've switched over to using git for development now, which makes things
much easier than the old cvs tree.  The tree can be found on both
kernel.org and github.com if you want to fork it and send us changes
easier:
	http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git
	http://github.com/gregkh/usbutils/tree/master

thanks,

greg k-h

-----------

Greg Kroah-Hartman (7):
      usb.ids: updated version of the file
      Remove the FSF address from the source files.
      update usbhid-dump to release 1.2
      add another Linux kernel usb id.
      updated usb.ids file
      lsusb-t.c: fix up some complier warnings
      add lsusb.h to fix some complier warnings.

Lukáš Nykrýn (1):
      Add more space to lsusb.py output

Sarah Sharp (2):
      lsusb: wSpeedsSupported is 2 bytes, not one.
      lsusb: bU2DevExitLat is little endian, not big endian.


