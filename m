Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0GFLJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 07:09:25 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:47329 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0GFLJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 07:09:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
Date: Tue, 6 Jul 2010 13:10:05 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20100706175332.952fec90.sfr@canb.auug.org.au> <201007061018.21674.laurent.pinchart@ideasonboard.com> <20100706185132.7dd72993.sfr@canb.auug.org.au>
In-Reply-To: <20100706185132.7dd72993.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007061310.06197.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tuesday 06 July 2010 10:51:32 Stephen Rothwell wrote:
> On Tue, 6 Jul 2010 10:18:20 +0200 Laurent Pinchart wrote:
> > > diff --cc include/linux/usb/video.h
> > > index 2d5b7fc,429c91a..0000000
> > > --- a/include/linux/usb/video.h
> > > +++ b/include/linux/usb/video.h
> > > @@@ -160,12 -160,402 +160,409 @@@
> > 
> > [snip]
> > 
> > >  +/* 4.1.2. Control Capabilities */
> > >  +#define UVC_CONTROL_CAP_GET                           (1 << 0)
> > >  +#define UVC_CONTROL_CAP_SET                           (1 << 1)
> > >  +#define UVC_CONTROL_CAP_DISABLED                      (1 << 2)
> > >  +#define UVC_CONTROL_CAP_AUTOUPDATE                    (1 << 3)
> > >  +#define UVC_CONTROL_CAP_ASYNCHRONOUS                  (1 << 4)
> > >  +
> > 
> > Can you move those to the first part of the header file, with the other
> > constants ?
> 
> Sure, I just put it there because of the section numbering in the
> comments.  This, of course, will not influence how the file looks after
> Linus merges it - unless the conflict is fixed up by one of the
> maintainers before Linus gets it.

I had the impression that the conflict resolutions in linux-next would end up 
in mainline. I must have been wrong, sorry.

Mauro, can the uvc-gadget patches go through the linux-media tree ?

-- 
Regards,

Laurent Pinchart
