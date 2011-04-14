Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab1DNOBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:01:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43300 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab1DNOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:01:03 -0400
Date: Thu, 14 Apr 2011 15:00:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110414140048.GB1452@sirena.org.uk>
References: <1299134429.100626.661279191478.0.gpush@pororo> <1302754859.2767.30.camel@pororo> <20110414100048.GB1611@n2100.arm.linux.org.uk> <1302776705.28876.113.camel@pasglop> <20110414103200.GF1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140751220.24613@xanadu.home> <20110414120904.GH1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140920110.24613@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104140920110.24613@xanadu.home>
X-Cookie: You are false data.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 09:39:58AM -0400, Nicolas Pitre wrote:
> On Thu, 14 Apr 2011, Russell King - ARM Linux wrote:

> > Adding it without anyone using it doesn't solve anything.  We need
> > people to commit to producing patches to use it for the next merge
> > window.

> People are simply waiting for the API to hit some upstream tree (like 
> yours) before committing to it.  You would be in a much better position 
> if those patches are in your tree, so that you can tell people: "Here's 
> the Git branch with the API in it, so now I'm expecting patches to 
> convert clock users to it".

One way of doing this would be to apply the patches to a branch in your
tree which isn't merged into -next and request that architecture
maintainers wishing to make use of the branch pull it into their trees.
That way it'll go into -next with at least one user but multiple
architectures can still work on using it in the initial merge.
