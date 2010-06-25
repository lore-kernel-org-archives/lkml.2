Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0FYH30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 03:29:26 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:39443 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0FYH3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 03:29:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nils Radtke <Nils.Radtke@think-future.de>
Subject: Re: [2.6.33.4 PATCH] V4L/uvcvideo: Add support for Suyin Corp. Lenovo Webcam
Date: Fri, 25 Jun 2010 09:29:28 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33; KDE/4.4.3; x86_64; ; )
Cc: laurent.pinchart@skynet.be, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>, stable@kernel.org
References: <20100623092316.GA13364@localhost> <201006231445.54883.laurent.pinchart@ideasonboard.com> <20100624181941.GE13364@localhost>
In-Reply-To: <20100624181941.GE13364@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006250929.29621.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nils,

On Thursday 24 June 2010 20:19:41 Nils Radtke wrote:
> On Wed 2010-06-23 @ 02-45-53PM +0200, Laurent Pinchart wrote:
> # On Wednesday 23 June 2010 11:23:16 Nils Radtke wrote:
> # > From: Nils Radtke <lkml@Think-Future.de>
> # >
> # > This patch adds support for the Suyin Corp. Lenovo Webcam.
> # > lsusb: ID 064e:a102 Suyin Corp. Lenovo Webcam
> # >
> # > It is available as built-in webcam i.e. in ACER timeline 1810t
> # > notebooks.
> # >
> # > The note in uvc_driver.c about Logitech cameras applies the same
> # > to the Suyin web cam: it doesn't announce itself as UVC devices
> # > but is compliant.
> # >
> # > Signed-off-by: Nils Radtke <lkml@Think-Future.de>
> #
> # Thanks for the patch. Could you please send me the output of lsusb -v for
> your
> 
> Bus 002 Device 002: ID 064e:a102 Suyin Corp. Lenovo Webcam

[snip]

>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass        14 Video
>       bInterfaceSubClass      1 Video Control
>       bInterfaceProtocol      0
>       iInterface              5 Webcam

This looks like a pretty standard UVC device. Are you sure your patch is 
needed ?

-- 
Regards,

Laurent Pinchart
