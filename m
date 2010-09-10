Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab0IJLPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:15:33 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33595 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0IJLPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:15:32 -0400
Date: Fri, 10 Sep 2010 13:15:30 +0200
From: Florian Mickler <florian@mickler.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        "Wolfram Sang (role:commit_signer)" <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910131530.688c1a1d@schatten.dmk.lab>
In-Reply-To: <20100910110425.GD23903@sirena.org.uk>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	<1284111767.1783.35.camel@Joe-Laptop>
	<20100910123040.5a6f0128@schatten.dmk.lab>
	<20100910110425.GD23903@sirena.org.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 12:04:31 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Fri, Sep 10, 2010 at 12:30:40PM +0200, Florian Mickler wrote:
> 
> > People that get angered by being cc'd a lot as commit_signers can always
> > filter their mail for that. 
> > But I don't think it is the major part of kernel hackers that get angry
> > when they are cc'd. Most kernel hackers _love_ getting mail, or not? :) 
> > At least they should.
> 
> Consider what happens if someone does lots of kernel wide changes or
> generic code cleanup work like the pattern matching cleanups.  As
> someone who gets some of this sort of stuff I find it's quite confusing
> when I get patches sent to me and I have to figure out what I'm supposed
> to do about them.

Yes, absolutely. That was what the patch was motivated by. 

> 
> > I think the --git thing is great, as it really get's patches into the
> > kernel vs letting them rot on some mailinglist.
> 
> It's a very useful tool - the issue is with people not realising that
> it's not infalible and taking the results blindly.

Yeah. I agree. That's why I think that making the "blindly take the
results" visible somehow would be nice. 

After all, if you can easy determine (or even have it filtered away)
that you were cc'd automatically it would spare you some time. 

I would probably don't have those mails be sent to my mobile device.
While I probably want things I'm cc'd manually tho. 

