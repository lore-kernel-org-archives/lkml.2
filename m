Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0GGPSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:18:52 -0400
Received: from kroah.org ([198.145.64.141]:60687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab0GGPSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:18:49 -0400
Date: Wed, 7 Jul 2010 08:13:55 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
Message-ID: <20100707151355.GB2121@kroah.com>
References: <20100706175332.952fec90.sfr@canb.auug.org.au>
 <201007061018.21674.laurent.pinchart@ideasonboard.com>
 <20100706185132.7dd72993.sfr@canb.auug.org.au>
 <201007061310.06197.laurent.pinchart@ideasonboard.com>
 <4C3322EB.2050806@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3322EB.2050806@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 09:34:51AM -0300, Mauro Carvalho Chehab wrote:
> Em 06-07-2010 08:10, Laurent Pinchart escreveu:
> > Hi Stephen,
> > 
> > On Tuesday 06 July 2010 10:51:32 Stephen Rothwell wrote:
> >> On Tue, 6 Jul 2010 10:18:20 +0200 Laurent Pinchart wrote:
> >>>> diff --cc include/linux/usb/video.h
> >>>> index 2d5b7fc,429c91a..0000000
> >>>> --- a/include/linux/usb/video.h
> >>>> +++ b/include/linux/usb/video.h
> >>>> @@@ -160,12 -160,402 +160,409 @@@
> >>>
> >>> [snip]
> >>>
> >>>>  +/* 4.1.2. Control Capabilities */
> >>>>  +#define UVC_CONTROL_CAP_GET                           (1 << 0)
> >>>>  +#define UVC_CONTROL_CAP_SET                           (1 << 1)
> >>>>  +#define UVC_CONTROL_CAP_DISABLED                      (1 << 2)
> >>>>  +#define UVC_CONTROL_CAP_AUTOUPDATE                    (1 << 3)
> >>>>  +#define UVC_CONTROL_CAP_ASYNCHRONOUS                  (1 << 4)
> >>>>  +
> >>>
> >>> Can you move those to the first part of the header file, with the other
> >>> constants ?
> >>
> >> Sure, I just put it there because of the section numbering in the
> >> comments.  This, of course, will not influence how the file looks after
> >> Linus merges it - unless the conflict is fixed up by one of the
> >> maintainers before Linus gets it.
> > 
> > I had the impression that the conflict resolutions in linux-next would end up 
> > in mainline. I must have been wrong, sorry.
> > 
> > Mauro, can the uvc-gadget patches go through the linux-media tree ?
> 
> If Greg is ok, that's fine for me.

That's fine with me.  Let me know when you have them and then I'll drop
them from my tree.

thanks,

greg k-h
