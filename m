Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1F0Iva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:51:30 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:37665 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab1F0Ite (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:49:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Subject: Re: [PATCH 16/37] Remove unneeded version.h includes (and add where needed) for drivers/usb/
Date: Mon, 27 Jun 2011 10:49:46 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.4; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net> <alpine.LNX.2.00.1106240030390.17688@swampdragon.chaosbits.net> <20110627082036.GE2508@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110627082036.GE2508@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271049.46580.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Monday 27 June 2011 10:20:37 Felipe Balbi wrote:
> On Fri, Jun 24, 2011 at 12:31:43AM +0200, Jesper Juhl wrote:
> > It was pointed out by 'make versioncheck' that linux/version.h was not
> > always being included where needed and sometimes included needlessly
> > in drivers/usb/.
> > This patch fixes up the includes.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Laurent, I guess Jesper needs your Ack for the uvc part. It looks good
> to me, but I'll leave it to you.

For the UVC gadget driver,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Sorry for the delay.

> > ---
> > 
> >  drivers/usb/gadget/uvc.h         |    1 +
> >  drivers/usb/gadget/uvc_v4l2.c    |    1 -
> >  drivers/usb/storage/realtek_cr.c |    1 -
> >  3 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
> > index 5b79194..81971fb 100644
> > --- a/drivers/usb/gadget/uvc.h
> > +++ b/drivers/usb/gadget/uvc.h
> > @@ -56,6 +56,7 @@ struct uvc_event
> > 
> >  #include <linux/usb.h>	/* For usb_endpoint_* */
> >  #include <linux/usb/gadget.h>
> >  #include <linux/videodev2.h>
> > 
> > +#include <linux/version.h>
> > 
> >  #include <media/v4l2-fh.h>
> >  
> >  #include "uvc_queue.h"
> > 
> > diff --git a/drivers/usb/gadget/uvc_v4l2.c
> > b/drivers/usb/gadget/uvc_v4l2.c index 5e807f0..a715805 100644
> > --- a/drivers/usb/gadget/uvc_v4l2.c
> > +++ b/drivers/usb/gadget/uvc_v4l2.c
> > @@ -16,7 +16,6 @@
> > 
> >  #include <linux/errno.h>
> >  #include <linux/list.h>
> >  #include <linux/mutex.h>
> > 
> > -#include <linux/version.h>
> > 
> >  #include <linux/videodev2.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/wait.h>
> > 
> > diff --git a/drivers/usb/storage/realtek_cr.c
> > b/drivers/usb/storage/realtek_cr.c index d509a4a..fe21104 100644
> > --- a/drivers/usb/storage/realtek_cr.c
> > +++ b/drivers/usb/storage/realtek_cr.c
> > @@ -26,7 +26,6 @@
> > 
> >  #include <linux/sched.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/kernel.h>
> > 
> > -#include <linux/version.h>
> > 
> >  #include <scsi/scsi.h>
> >  #include <scsi/scsi_cmnd.h>

-- 
Regards,

Laurent Pinchart
