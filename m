Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0GZVpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 17:45:05 -0400
Received: from kroah.org ([198.145.64.141]:35101 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab0GZVpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 17:45:01 -0400
Date: Mon, 26 Jul 2010 14:42:09 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
Message-ID: <20100726214209.GB21158@kroah.com>
References: <20100706175332.952fec90.sfr@canb.auug.org.au>
 <201007131923.31877.laurent.pinchart@ideasonboard.com>
 <4C4B07A6.4050009@infradead.org>
 <201007261024.05863.laurent.pinchart@ideasonboard.com>
 <4C4D953F.4050700@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4D953F.4050700@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 11:01:35AM -0300, Mauro Carvalho Chehab wrote:
> Em 26-07-2010 05:24, Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > On Saturday 24 July 2010 17:32:54 Mauro Carvalho Chehab wrote:
> >> Em 13-07-2010 14:23, Laurent Pinchart escreveu:
> >>> On Tuesday 13 July 2010 17:34:02 Mauro Carvalho Chehab wrote:
> >>>> Em 07-07-2010 12:13, Greg KH escreveu:
> >>>>> On Tue, Jul 06, 2010 at 09:34:51AM -0300, Mauro Carvalho Chehab wrote:
> >>>>>> Em 06-07-2010 08:10, Laurent Pinchart escreveu:
> >>> [snip]
> >>>
> >>>>>>> Mauro, can the uvc-gadget patches go through the linux-media tree ?
> >>>>
> >>>> It will not be simple to fix this conflict from my tree. I tried to
> >>>> apply
> >>>>
> >>>> them against a 2.6.35-rc5, but it failed:
> >>>> |diff --git a/drivers/media/video/uvc/uvcvideo.h
> >>>> |b/drivers/media/video/uvc/uvcvideo.h index 47b20e7..ac27245 100644
> >>>> |--- a/drivers/media/video/uvc/uvcvideo.h
> >>>> |+++ b/drivers/media/video/uvc/uvcvideo.h
> >>>>
> >>>> --------------------------
> >>>> No file to patch.  Skipping patch.
> >>>> 1 out of 1 hunk ignored
> >>>> can't find file to patch at input line 73
> >>>> Perhaps you used the wrong -p or --strip option?
> >>>
> >>> drivers/media/video/uvc/uvcvideo.h has been there for years. Perhaps you
> >>> used the wrong -p or --strip option? :-)
> >>
> >> Doubtful. My scripts apply the patches using -p1. Not sure what happened.
> > 
> > [snip]
> > 
> >> Could you please re-send the patch, being sure that it will apply against a
> >> -rc kernel?
> > 
> > The patch I've sent you applies unmodified against 2.6.35-rc6. I'm pretty sure 
> > you made a mistake somewhere.
> 
> Likely. I've just applied it to my trees. This time, it applied fine.

Ok, I've dropped the patch from my usb tree right now.

thanks,

greg k-h
