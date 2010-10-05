Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0JEFhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:37:24 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:42545
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281Ab0JEFhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:37:22 -0400
Date: Mon, 4 Oct 2010 22:35:20 -0700
From: matt mooney <mfm@muteddisk.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: walter harms <wharms@bfs.de>, Tracey Dent <tdent48227@gmail.com>,
        greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3 01/20] Staging: cx25821: Makefile: cleaned up
 Makefile cflag lines
Message-ID: <20101005053520.GC6369@haskell.muteddisk.com>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	walter harms <wharms@bfs.de>, Tracey Dent <tdent48227@gmail.com>,
	greg@kroah.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
 <4CA879A1.3070400@bfs.de>
 <20101003205128.GA16185@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101003205128.GA16185@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:51 Sun 03 Oct     , Sam Ravnborg wrote:
> On Sun, Oct 03, 2010 at 02:40:01PM +0200, walter harms wrote:
> > 
> > 
> > Tracey Dent schrieb:
> > > Changed to use the proper ccflags-y option
> > > 
> > > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> > > ---
> > >  drivers/staging/cx25821/Makefile |    8 ++++----
> > >  1 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
> > > index d0eb16e..6448364 100644
> > > --- a/drivers/staging/cx25821/Makefile
> > > +++ b/drivers/staging/cx25821/Makefile
> > > @@ -7,7 +7,7 @@ cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
> > >  obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
> > >  obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
> > >  
> > > -EXTRA_CFLAGS += -Idrivers/media/video
> > > -EXTRA_CFLAGS += -Idrivers/media/common/tuners
> > > -EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
> > > -EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
> > > +ccflags-y := -Idrivers/media/video
> > > +ccflags-y += -Idrivers/media/common/tuners
> > > +ccflags-y += -Idrivers/media/dvb/dvb-core
> > > +ccflags-y += -Idrivers/media/dvb/frontends
> > 
> > they have invented vpath for this, did they ?
> > note: I am not familiar with the linux makefile.
> vpath is not the answer here.
> 
> Note that Tracy dent did the simple replacement of EXTRA_CFLAGS with ccflags-y.
> The Makefiles could in many cases benefit from general cleanups - which many
> of your futher comments is a good indicator of.

Hi Sam,

I happen to have sent out a RFC patch for media/ a little over a week ago.
Mauro Chehab has not commented on it yet, but I am curious to hear your
opinion.

http://marc.info/?l=linux-kernel&m=128553496013767&w=2

Thanks,
mfm

