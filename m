Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab1IAXdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 19:33:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:55246 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab1IAXc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 19:32:58 -0400
Subject: Re: [PATCH] i2c: remove deprecated callbacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Randy Dunlap <rdunlap@xenotime.net>,
        Ben Dooks <ben-linux@fluff.org>, linux-doc@vger.kernel.org,
        linux-i2c@vger.kernel.org
In-Reply-To: <1314919458.4145.23.camel@pasglop>
References: <1314852027-9523-1-git-send-email-xiyou.wangcong@gmail.com>
	 <20110901105226.0d8dd8b2@endymion.delvare>
	 <1314919458.4145.23.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 09:32:07 +1000
Message-ID: <1314919927.4145.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-02 at 09:24 +1000, Benjamin Herrenschmidt wrote:


 .../...

> I'm just bogged down by too many things, including quite a bit of travel
> lately. I have some mostly untested patches converting part of windfarm
> (not all of it yet), and therm_adt746x and a patch to add the generic
> code to register i2c devices from device-tree properly on powermacs.
> 
> I'm missing a couple more drivers & bits of windfarm and therm_pm72
> which I'd like to use the opportunity to convert into a windfarm module.

I'll push out my WIP to a branch on powerpc.git on k.org when hera is
back online so those who want can help.

Cheers,
Ben.

> Then there's some sound drivers etc...
> 
> I am travelling again tomorrow for 2 weeks, and after that a month in
> europe, tho I'll have 10 days in the middle where I _might_ be able to
> make progress on that. Else it will have to wait for november.
>  
> > Cong, do you have a specific interest in these callbacks being removed?
> > 
> > If you want to help, then instead of sending a patch which I already
> > have and virtually everybody could have written, please get the
> > remaining 3 drivers converted to the current i2c binding model:
> >   sound/ppc/keywest.c
> >   sound/aoa/codecs/onyx.c
> >   sound/aoa/codecs/tas.c
> > THAT would be helpful. At the moment, it only looks like you are trying
> > to get your name on a trivial patch, i.e. getting credit for work you
> > didn't really do.
> 
> Cheers,
> Ben.
> 
> > > 
> > > ---
> > > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > > index c4a6e14..89a9695 100644
> > > --- a/Documentation/feature-removal-schedule.txt
> > > +++ b/Documentation/feature-removal-schedule.txt
> > > @@ -486,15 +486,6 @@ Files:	include/linux/netfilter_ipv4/ipt_addrtype.h
> > >  
> > >  ----------------------------
> > >  
> > > -What:	i2c_driver.attach_adapter
> > > -	i2c_driver.detach_adapter
> > > -When:	September 2011
> > > -Why:	These legacy callbacks should no longer be used as i2c-core offers
> > > -	a variety of preferable alternative ways to instantiate I2C devices.
> > > -Who:	Jean Delvare <khali@linux-fr.org>
> > > -
> > > -----------------------------
> > > -
> > > (...)
> > 
> 


