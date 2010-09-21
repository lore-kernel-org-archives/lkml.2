Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0IUUrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 16:47:46 -0400
Received: from kroah.org ([198.145.64.141]:39876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab0IUUrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 16:47:43 -0400
Date: Tue, 21 Sep 2010 13:35:44 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] drivers/usb/gadget: Remove pr_<level> uses of
 KERN_<level>
Message-ID: <20100921203544.GC25112@kroah.com>
References: <cover.1284267142.git.joe@perches.com>
 <141dd5ea20749b4b37d60cae53d1751bb88ba15c.1284267142.git.joe@perches.com>
 <1285085494.6816.0.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285085494.6816.0.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 09:11:34AM -0700, Joe Perches wrote:
> On Sat, 2010-09-11 at 22:10 -0700, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/usb/gadget/r8a66597-udc.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
> > index 2456ccd..8040c85 100644
> > --- a/drivers/usb/gadget/r8a66597-udc.c
> > +++ b/drivers/usb/gadget/r8a66597-udc.c
> > @@ -274,7 +274,7 @@ static int pipe_buffer_setting(struct r8a66597 *r8a66597,
> >  	}
> >  
> >  	if (buf_bsize && ((bufnum + 16) >= R8A66597_MAX_BUFNUM)) {
> > -		pr_err(KERN_ERR "r8a66597 pipe memory is insufficient\n");
> > +		pr_err("r8a66597 pipe memory is insufficient\n");
> >  		return -ENOMEM;
> >  	}
> >  
> 
> Ping?

Sorry for the delay, now applied.

greg k-h
