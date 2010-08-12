Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194Ab0HLXoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 19:44:08 -0400
Received: from kroah.org ([198.145.64.141]:59562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab0HLXoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 19:44:06 -0400
Date: Thu, 12 Aug 2010 16:43:36 -0700
From: Greg KH <greg@kroah.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: usbutils 0.90 release
Message-ID: <20100812234336.GA17737@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the 0.90 release of usbutils.

Big thing is support for the audio class descriptors.  Other than that,
it's just a lot of little things, as can be seen in the changelog below.

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
      fix bcdDFUVersion endianness

Chris Clayton (1):
      Patch to add additional devices to usb.ids

Daniel Mack (7):
      dump_audiostreaming_interface(): fix ac-3 decoder
      parse USB audio class 2 control interface types
      parse USB audio class 2 streaming interfaces
      parse USB audio class 2 endpoints
      dump_audio_bmcontrols(): tell users about faulty bmControl bits
      dump_audiostreaming_interface(): drop audio class 2 FORMAT_TYPE length check
      lsusb: fix iFeature position calculation for UAC2 feature units

Greg Kroah-Hartman (6):
      reserve a USB Ethernet Gadget driver device id.
      fix up wording of NCM Ethernet gadget device id
      fix up some signed/unsigned warnings in lsusb.c
      move #defines around a bit to make it more orderly.
      more gadget device ids reserved for the Linux Foundation vendor id
      Fix up a lot of memory leaks

Ludovic Rousseau (1):
      Update Gemplus id

Matthew Wilcox (1):
      Decode USB 3 Endpoint Companion Descriptors

Nix (1):
      Include config.h before everything else.

