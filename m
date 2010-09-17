Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0IQKf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 06:35:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50050 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab0IQKfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 06:35:55 -0400
Date: Fri, 17 Sep 2010 11:35:20 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Sundar R IYER <sundar.iyer@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: FW: next build fails
Message-ID: <20100917103520.GA30330@flint.arm.linux.org.uk>
References: <33A307AF30D7BF4F811B1568FE7A9B18043784FF99@EXDCVYMBSTM006.EQ1STM.local> <20100916164442.df749cc1.sfr@canb.auug.org.au> <1284656407.2411.5.camel@c-dwalke-linux.qualcomm.com> <20100917075242.e0bc4b54.sfr@canb.auug.org.au> <1284674337.2411.53.camel@c-dwalke-linux.qualcomm.com> <20100917080439.7c35775a.sfr@canb.auug.org.au> <1284674935.2411.54.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284674935.2411.54.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 03:08:55PM -0700, Daniel Walker wrote:
> On Fri, 2010-09-17 at 08:04 +1000, Stephen Rothwell wrote:
> > Hi Daniel,
> > 
> > On Thu, 16 Sep 2010 14:58:57 -0700 Daniel Walker <dwalker@fifo99.com> wrote:
> > >
> > > Yeah, exactly .. This is what I did to update my patch .. Do you want to
> > > include this, or should I update my version and my tree.. Ultimately my
> > > version has to go into Russell's tree..
> > 
> > Well, you can't really update that in your tree until after your tree is
> > merged with Russell's, right (since ALT_UP etc are not defined in your
> > tree)?  In that case, I need to do the fix when I merge your tree into
> > linux-next (and so with Russell's tree).
> 
> Right, I see what your saying .. Ok, thanks.

There is another way to handle this - we shouldn't be tinkering with
the aux control register on non-ARM cores (as we don't know what the
bits on such cores do) we could view this as a bug fix, and put it
into -rc.

I'd prefer to do that - so could you send the original patch you posted
to lakml to the patch system please?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
