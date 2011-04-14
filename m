Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab1DNKcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:32:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42128 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666Ab1DNKcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:32:46 -0400
Date: Thu, 14 Apr 2011 11:32:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110414103200.GF1611@n2100.arm.linux.org.uk>
References: <1299134429.100626.661279191478.0.gpush@pororo> <1302754859.2767.30.camel@pororo> <20110414100048.GB1611@n2100.arm.linux.org.uk> <1302776705.28876.113.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302776705.28876.113.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 08:25:05PM +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2011-04-14 at 11:00 +0100, Russell King - ARM Linux wrote:
> > 
> > I will take it, but at the moment I'm rather unhappy about the response
> > from the community to Linus' complaint.
> > 
> > If existing platform maintainers can show that moving over to this will
> > result in a net reduction of code under arch/arm, then that will be good.
> > What I don't want to see at the moment is arch/arm increasing in size as
> > a result of any change.  We desperately need to see a reduction for the
> > next merge window.
> 
> It's a chicken and egg... platform maintainers wait for you to take it
> and you wait for them to take it :-)
> 
> It seems to me that this fits well into the category of "better common
> abstractions" that was discussed in the thread initiated by Linus as one
> of the ways to improve on the "clutter"...

That depends - sometimes creating generic stuff results in a net increase
in the overall size, and that's something that Linus also complained about.

According to linux-next, where we are at the moment with arch/arm is a
net increase of 6000 lines since the close of the last merge window,
and arch/arm is responsible for almost 75% of arch/ changes.  It looks
very much like the same situation which Linus complained about.

Can arch/arm continue to increase in size?  I think not.  We desperately
need patches which reduce the size of arch/arm, and we desperately need
them *now*.
