Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0I3G0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:26:02 -0400
Received: from kroah.org ([198.145.64.141]:53247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab0I3GYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:24:45 -0400
Date: Wed, 29 Sep 2010 23:18:52 -0700
From: Greg KH <greg@kroah.com>
To: walter harms <wharms@bfs.de>
Cc: Tracey Dent <tdent48227@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/22] Staging: rtl8187se: Makefile: cleaned up
	makefile cflag lines
Message-ID: <20100930061852.GA8707@kroah.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com> <1285370890-8984-11-git-send-email-tdent48227@gmail.com> <4C9DD2A4.6080508@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9DD2A4.6080508@bfs.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 12:44:52PM +0200, walter harms wrote:
> 
> 
> Tracey Dent schrieb:
> > Changed to use proper ccflags-y option
> > 
> > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> > ---
> >  drivers/staging/rtl8187se/Makefile |   20 ++++++++++----------
> >  1 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
> > index e6adf91..51fbd24 100644
> > --- a/drivers/staging/rtl8187se/Makefile
> > +++ b/drivers/staging/rtl8187se/Makefile
> > @@ -1,20 +1,20 @@
> >  
> > -#EXTRA_CFLAGS += -DCONFIG_IEEE80211_NOWEP=y
> > -#EXTRA_CFLAGS += -std=gnu89
> > -#EXTRA_CFLAGS += -O2
> > +#ccflags-y := -DCONFIG_IEEE80211_NOWEP=y
> > +#ccflags-y := -std=gnu89
> > +#ccflags-y := -O2
> >  #CC            = gcc
> >  
> > -EXTRA_CFLAGS += -DSW_ANTE
> > -EXTRA_CFLAGS += -DTX_TRACK
> > -EXTRA_CFLAGS += -DHIGH_POWER
> > -EXTRA_CFLAGS += -DSW_DIG
> > -EXTRA_CFLAGS += -DRATE_ADAPT
> > +ccflags-y := -DSW_ANTE
> > +ccflags-y := -DTX_TRACK
> > +ccflags-y := -DHIGH_POWER
> > +ccflags-y := -DSW_DIG
> > +ccflags-y := -DRATE_ADAPT
> >  
> >  #enable it for legacy power save, disable it for leisure  power save
> > -EXTRA_CFLAGS += -DENABLE_LPS
> > +ccflags-y := -DENABLE_LPS
> >  
> >  
> > -#EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
> > +#ccflags-y := -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
> >  
> 
> I do not understand this. If CONFIG_FORCE_HARD_FLOAT is required by the
> driver so he should fail if CONFIG_FORCE_HARD_FLOAT=n
> Or you need to protect the -mhard-float with an if().

That line is commented out, it doesn't do anything, so I wouldn't worry
about it :)

thanks,

greg k-h
