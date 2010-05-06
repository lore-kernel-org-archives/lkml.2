Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0EFH4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:56:32 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:44473 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0EFH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:56:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] usb gadget webcam: depends on VIDEO_DEV
Date: Thu, 6 May 2010 09:57:13 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33; KDE/4.4.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, lud <linux-usb@vger.kernel.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de
References: <20100505123409.ed5678a2.sfr@canb.auug.org.au> <20100505154626.2c036f1d.randy.dunlap@oracle.com>
In-Reply-To: <20100505154626.2c036f1d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005060957.13833.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Thursday 06 May 2010 00:46:26 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> g_webcam uses v4l[2] interfaces, so it should depend on VIDEO_DEV.
> 
> ERROR: "v4l2_event_unsubscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_event_queue" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "video_device_release" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "video_usercopy" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_event_dequeue" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "video_register_device" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "video_device_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_event_subscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "video_unregister_device" [drivers/usb/gadget/g_webcam.ko] ndefined!
> ERROR: "v4l2_event_pending" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_fh_init" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_event_init" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "video_devdata" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_event_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_fh_add" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_fh_del" [drivers/usb/gadget/g_webcam.ko] undefined!
> ERROR: "v4l2_fh_exit" [drivers/usb/gadget/g_webcam.ko] undefined!

Oops, my bad. Thanks for the patch.

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
