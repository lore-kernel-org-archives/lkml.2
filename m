Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab0GFIRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:17:37 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:49984 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab0GFIRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:17:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
Date: Tue, 6 Jul 2010 10:18:20 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20100706175332.952fec90.sfr@canb.auug.org.au>
In-Reply-To: <20100706175332.952fec90.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007061018.21674.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tuesday 06 July 2010 09:53:32 Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/media/video/uvc/uvcvideo.h include/linux/usb/video.h between
> commits c3810b43416155d040a200e7a7301f379c8ae8a0 ("V4L/DVB: uvcvideo:
> Support menu controls in the control mapping API") and
> da1df555fcbb98a9d2054304ea54545d9ff523cf ("V4L/DVB: uvcvideo: Define
> control information bits using macros") from the v4l-dvb tree and commit
> bb03b5daa9ab053adcce09e939d4115a873abf39 ("USB: uvc: Move constants and
> structures definitions to linux/usb/video.h") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.  Though
> moving the USB patch into the v4l-dvb tree may fix the conflicts as
> well ...

[snip]

> diff --cc include/linux/usb/video.h
> index 2d5b7fc,429c91a..0000000
> --- a/include/linux/usb/video.h
> +++ b/include/linux/usb/video.h
> @@@ -160,12 -160,402 +160,409 @@@

[snip]

>  +/* 4.1.2. Control Capabilities */
>  +#define UVC_CONTROL_CAP_GET                           (1 << 0)
>  +#define UVC_CONTROL_CAP_SET                           (1 << 1)
>  +#define UVC_CONTROL_CAP_DISABLED                      (1 << 2)
>  +#define UVC_CONTROL_CAP_AUTOUPDATE                    (1 << 3)
>  +#define UVC_CONTROL_CAP_ASYNCHRONOUS                  (1 << 4)
>  +

Can you move those to the first part of the header file, with the other 
constants ?

-- 
Regards,

Laurent Pinchart
