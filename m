Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0FZKgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 06:36:31 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:36141 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab0FZKg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 06:36:29 -0400
Date: Sat, 26 Jun 2010 12:36:15 +0200
From: Nils Radtke <Nils.Radtke@Think-Future.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       stable@kernel.org
Subject: Re: [2.6.33.4 PATCH] V4L/uvcvideo: Add support for Suyin Corp.
 Lenovo Webcam
Message-ID: <20100626103615.GE8384@localhost>
Reply-To: Nils Radtke <Nils.Radtke@Think-Future.de>
References: <20100623092316.GA13364@localhost>
 <201006231445.54883.laurent.pinchart@ideasonboard.com>
 <20100624181941.GE13364@localhost>
 <201006250929.29621.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006250929.29621.laurent.pinchart@ideasonboard.com>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Laurent,

On ven 2010-06-25 @ 09-29-28 +0200, Laurent Pinchart wrote: 
# Hi Nils,
# 
# On Thursday 24 June 2010 20:19:41 Nils Radtke wrote:
# > On Wed 2010-06-23 @ 02-45-53PM +0200, Laurent Pinchart wrote:
# > # On Wednesday 23 June 2010 11:23:16 Nils Radtke wrote:
# > # > From: Nils Radtke <lkml@Think-Future.de>
# > # >
# > # > This patch adds support for the Suyin Corp. Lenovo Webcam.
# > # > lsusb: ID 064e:a102 Suyin Corp. Lenovo Webcam
# > # >
# > # > It is available as built-in webcam i.e. in ACER timeline 1810t
# > # > notebooks.
# > # >
# > # > The note in uvc_driver.c about Logitech cameras applies the same
# > # > to the Suyin web cam: it doesn't announce itself as UVC devices
# > # > but is compliant.
# > # >
# > # > Signed-off-by: Nils Radtke <lkml@Think-Future.de>
# > #
# > # Thanks for the patch. Could you please send me the output of lsusb -v for
# > your
# > 
# > Bus 002 Device 002: ID 064e:a102 Suyin Corp. Lenovo Webcam
# 
# [snip]
# 
# >     Interface Descriptor:
# >       bLength                 9
# >       bDescriptorType         4
# >       bInterfaceNumber        0
# >       bAlternateSetting       0
# >       bNumEndpoints           1
# >       bInterfaceClass        14 Video
# >       bInterfaceSubClass      1 Video Control
# >       bInterfaceProtocol      0
# >       iInterface              5 Webcam
# 
# This looks like a pretty standard UVC device. Are you sure your patch is 
# needed ?
Indeed. Hm, about whether the patch is needed.. What happened here was: the module
didn't get loaded w/o the patch. But then maybe something else made the change? 
After subsequent reboot the module did get loaded. Hm..

Isn't the vendor/product ID a point of reference that tells the kernel which module
to load when supported hw is found? That was the idea behind adding the ID and
submitting the patch. 

Thanks for clarification.

        Cheers, 

                  Nils

