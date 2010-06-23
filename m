Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0FWMp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 08:45:57 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:56321 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0FWMpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 08:45:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nils Radtke <lkml@think-future.de>
Subject: Re: [2.6.33.4 PATCH] V4L/uvcvideo: Add support for Suyin Corp. Lenovo Webcam
Date: Wed, 23 Jun 2010 14:45:53 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33; KDE/4.4.3; x86_64; ; )
Cc: laurent.pinchart@skynet.be, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>, stable@kernel.org
References: <20100623092316.GA13364@localhost>
In-Reply-To: <20100623092316.GA13364@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006231445.54883.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nils,

On Wednesday 23 June 2010 11:23:16 Nils Radtke wrote:
> From: Nils Radtke <lkml@Think-Future.de>
> 
> This patch adds support for the Suyin Corp. Lenovo Webcam.
> lsusb: ID 064e:a102 Suyin Corp. Lenovo Webcam
> 
> It is available as built-in webcam i.e. in ACER timeline 1810t
> notebooks.
> 
> The note in uvc_driver.c about Logitech cameras applies the same
> to the Suyin web cam: it doesn't announce itself as UVC devices
> but is compliant.
> 
> Signed-off-by: Nils Radtke <lkml@Think-Future.de>

Thanks for the patch. Could you please send me the output of lsusb -v for your 
camera, as well as the raw binary descriptors ? You can retrieve the later 
with

cat /proc/bus/usb/xxx/yyy

Replace xxx with the device bus number, and yyy with the device number. Both 
can be retrieved from /proc/bus/usb/devices.

-- 
Regards,

Laurent Pinchart
