Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0I2W5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:57:25 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:40996
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242Ab0I2W5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:57:23 -0400
Date: Wed, 29 Sep 2010 15:55:54 -0700
From: matt mooney <mfm@muteddisk.com>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: kernel-janitors@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/24] misc: change to new flag variable
Message-ID: <20100929225553.GA19372@haskell.muteddisk.com>
Mail-Followup-To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	kernel-janitors@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
	linux-kernel@vger.kernel.org
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
 <20100928130214.GC3388@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100928130214.GC3388@rere.qmqm.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:02 Tue 28 Sep     , Michał Mirosław wrote:
> On Fri, Sep 24, 2010 at 12:17:23PM -0700, matt mooney wrote:
> > Replace EXTRA_CFLAGS with ccflags-y.
> > 
> > Signed-off-by: matt mooney <mfm@muteddisk.com>
> > ---
> >  drivers/misc/cb710/Makefile   |    4 +---
> >  drivers/misc/sgi-gru/Makefile |    4 +---
> >  2 files changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/misc/cb710/Makefile b/drivers/misc/cb710/Makefile
> > index 7b80cbf..467c8e9 100644
> > --- a/drivers/misc/cb710/Makefile
> > +++ b/drivers/misc/cb710/Makefile
> > @@ -1,6 +1,4 @@
> > -ifeq ($(CONFIG_CB710_DEBUG),y)
> > -	EXTRA_CFLAGS		+= -DDEBUG
> > -endif
> > +ccflags-$(CONFIG_CB710_DEBUG)	:= -DDEBUG
> >  
> >  obj-$(CONFIG_CB710_CORE)	+= cb710.o
> >  
> 
> In case you need it:
> 
> Acked-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>

Always helps!

Thanks,
mfm
