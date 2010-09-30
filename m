Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0I3GY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:24:59 -0400
Received: from kroah.org ([198.145.64.141]:53251 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab0I3GY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:24:57 -0400
Date: Wed, 29 Sep 2010 23:19:26 -0700
From: Greg KH <greg@kroah.com>
To: walter harms <wharms@bfs.de>
Cc: Tracey Dent <tdent48227@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/22] Staging: rtl8192u: Makefile: cleaned up
	makefile cflag lines
Message-ID: <20100930061926.GB8707@kroah.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com> <1285370890-8984-15-git-send-email-tdent48227@gmail.com> <4C9DD47C.7040403@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9DD47C.7040403@bfs.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 12:52:44PM +0200, walter harms wrote:
> 
> 
> Tracey Dent schrieb:
> > Changed to use proper ccflags-y option
> > 
> > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> > ---
> >  drivers/staging/rtl8192u/Makefile |   20 ++++++++++----------
> >  1 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/staging/rtl8192u/Makefile b/drivers/staging/rtl8192u/Makefile
> > index 738f4a8..1710921 100644
> > --- a/drivers/staging/rtl8192u/Makefile
> > +++ b/drivers/staging/rtl8192u/Makefile
> > @@ -1,16 +1,16 @@
> >  NIC_SELECT = RTL8192U
> >  
> > -EXTRA_CFLAGS += -std=gnu89
> > -EXTRA_CFLAGS += -O2
> > +ccflags-y := -std=gnu89
> > +ccflags-y := -O2
> >  
> 
> Is this -O2 a requirement ? I did not look into other makefiles but i would expect
> -O2 to be set in the main-makefile. (Imagine someone disables the optimsation only
> to find a driver that does behave different).

Yes, it should be removed, but that's not the goal of this patch.

> > -EXTRA_CFLAGS += -DCONFIG_FORCE_HARD_FLOAT=y
> > -EXTRA_CFLAGS += -DJACKSON_NEW_8187 -DJACKSON_NEW_RX
> > -EXTRA_CFLAGS += -DTHOMAS_BEACON -DTHOMAS_TASKLET -DTHOMAS_SKB -DTHOMAS_TURBO
> 
> Is THOMAS_BEACON etc a defined algorithem or so ? If not a bit more desciptive name
> would be nice

Lots of things would be "nice" for this driver :)

thanks,

greg k-h
