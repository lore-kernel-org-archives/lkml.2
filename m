Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1DNKBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:01:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37233 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab1DNKBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:01:10 -0400
Date: Thu, 14 Apr 2011 11:00:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110414100048.GB1611@n2100.arm.linux.org.uk>
References: <1299134429.100626.661279191478.0.gpush@pororo> <1302754859.2767.30.camel@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302754859.2767.30.camel@pororo>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 12:20:59PM +0800, Jeremy Kerr wrote:
> Any updates on these patches? I've added to your patch-tracker, would
> you expect these to make the next merge window, or are there changes
> you'd like made first?
> 
> Reason I ask is that I have a few queries from platform maintainers that
> would like to complete their clock ports to this API, but don't want to
> commit until the interface has been accepted, in at least an initial
> form.

I will take it, but at the moment I'm rather unhappy about the response
from the community to Linus' complaint.

If existing platform maintainers can show that moving over to this will
result in a net reduction of code under arch/arm, then that will be good.
What I don't want to see at the moment is arch/arm increasing in size as
a result of any change.  We desperately need to see a reduction for the
next merge window.
