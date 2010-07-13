Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab0GMRXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:23:40 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:48144 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab0GMRXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:23:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
Date: Tue, 13 Jul 2010 19:23:31 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100706175332.952fec90.sfr@canb.auug.org.au> <20100707151355.GB2121@kroah.com> <4C3C876A.5090005@infradead.org>
In-Reply-To: <4C3C876A.5090005@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007131923.31877.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Tuesday 13 July 2010 17:34:02 Mauro Carvalho Chehab wrote:
> Em 07-07-2010 12:13, Greg KH escreveu:
> > On Tue, Jul 06, 2010 at 09:34:51AM -0300, Mauro Carvalho Chehab wrote:
> >> Em 06-07-2010 08:10, Laurent Pinchart escreveu:

[snip]

> >>> Mauro, can the uvc-gadget patches go through the linux-media tree ?
> 
> It will not be simple to fix this conflict from my tree. I tried to apply
> them against a 2.6.35-rc5, but it failed:
> |diff --git a/drivers/media/video/uvc/uvcvideo.h
> |b/drivers/media/video/uvc/uvcvideo.h index 47b20e7..ac27245 100644
> |--- a/drivers/media/video/uvc/uvcvideo.h
> |+++ b/drivers/media/video/uvc/uvcvideo.h
> 
> --------------------------
> No file to patch.  Skipping patch.
> 1 out of 1 hunk ignored
> can't find file to patch at input line 73
> Perhaps you used the wrong -p or --strip option?

drivers/media/video/uvc/uvcvideo.h has been there for years. Perhaps you used 
the wrong -p or --strip option? :-)

[snip]

> >>> Patch
> >>> patches/lmml_111238_for_2_6_36_uvc_move_constants_and_structures_defin
> >>> itions_to_linux_usb_video_h.patch doesn't apply
> 
> It seems that the files you're patching at include/linux/usb & cia are not
> upstream yet. So, just adding this patch won't solve it.
> 
> >> If Greg is ok, that's fine for me.
> > 
> > That's fine with me.  Let me know when you have them and then I'll drop
> > them from my tree.
> 
> I'll be out for vacations for some days. Greg/Laurent, it seems that the
> better is to keep Stephen workaround for now, eventually applying it at
> Greg's tree.

If it's not too late, can you retry with the right -p option ?

-- 
Regards,

Laurent Pinchart
