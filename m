Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab1DNK0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:26:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:45314 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758708Ab1DNK0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:26:08 -0400
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110414100048.GB1611@n2100.arm.linux.org.uk>
References: <1299134429.100626.661279191478.0.gpush@pororo>
	 <1302754859.2767.30.camel@pororo>
	 <20110414100048.GB1611@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 20:25:05 +1000
Message-ID: <1302776705.28876.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 11:00 +0100, Russell King - ARM Linux wrote:
> 
> I will take it, but at the moment I'm rather unhappy about the response
> from the community to Linus' complaint.
> 
> If existing platform maintainers can show that moving over to this will
> result in a net reduction of code under arch/arm, then that will be good.
> What I don't want to see at the moment is arch/arm increasing in size as
> a result of any change.  We desperately need to see a reduction for the
> next merge window.

It's a chicken and egg... platform maintainers wait for you to take it
and you wait for them to take it :-)

It seems to me that this fits well into the category of "better common
abstractions" that was discussed in the thread initiated by Linus as one
of the ways to improve on the "clutter"...

Cheers,
Ben.


