Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0IQPoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:44:38 -0400
Received: from fifo99.com ([67.223.236.141]:43172 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab0IQPoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:44:37 -0400
Subject: Re: FW: next build fails
From: Daniel Walker <dwalker@fifo99.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Sundar R IYER <sundar.iyer@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100917103520.GA30330@flint.arm.linux.org.uk>
References: <33A307AF30D7BF4F811B1568FE7A9B18043784FF99@EXDCVYMBSTM006.EQ1STM.local>
	 <20100916164442.df749cc1.sfr@canb.auug.org.au>
	 <1284656407.2411.5.camel@c-dwalke-linux.qualcomm.com>
	 <20100917075242.e0bc4b54.sfr@canb.auug.org.au>
	 <1284674337.2411.53.camel@c-dwalke-linux.qualcomm.com>
	 <20100917080439.7c35775a.sfr@canb.auug.org.au>
	 <1284674935.2411.54.camel@c-dwalke-linux.qualcomm.com>
	 <20100917103520.GA30330@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 08:44:24 -0700
Message-ID: <1284738264.4177.25.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 11:35 +0100, Russell King wrote:
> On Thu, Sep 16, 2010 at 03:08:55PM -0700, Daniel Walker wrote:
> > On Fri, 2010-09-17 at 08:04 +1000, Stephen Rothwell wrote:
> > > Hi Daniel,
> > > 
> > > On Thu, 16 Sep 2010 14:58:57 -0700 Daniel Walker <dwalker@fifo99.com> wrote:
> > > >
> > > > Yeah, exactly .. This is what I did to update my patch .. Do you want to
> > > > include this, or should I update my version and my tree.. Ultimately my
> > > > version has to go into Russell's tree..
> > > 
> > > Well, you can't really update that in your tree until after your tree is
> > > merged with Russell's, right (since ALT_UP etc are not defined in your
> > > tree)?  In that case, I need to do the fix when I merge your tree into
> > > linux-next (and so with Russell's tree).
> > 
> > Right, I see what your saying .. Ok, thanks.
> 
> There is another way to handle this - we shouldn't be tinkering with
> the aux control register on non-ARM cores (as we don't know what the
> bits on such cores do) we could view this as a bug fix, and put it
> into -rc.

Yeah, it does seem to fit that category ..

> I'd prefer to do that - so could you send the original patch you posted
> to lakml to the patch system please?

Ok, I submitted it to your patch system (I'm assuming that's what you
mean by "patch system above").

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6398/1

Daniel

