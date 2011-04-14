Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1DNRUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:20:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54719 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1DNRUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:20:47 -0400
Date: Thu, 14 Apr 2011 19:20:17 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
Message-ID: <20110414172017.GD31990@pengutronix.de>
References: <1299134429.100626.661279191478.0.gpush@pororo>
 <1302754859.2767.30.camel@pororo>
 <20110414100048.GB1611@n2100.arm.linux.org.uk>
 <1302776705.28876.113.camel@pasglop>
 <20110414103200.GF1611@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1104140751220.24613@xanadu.home>
 <20110414120904.GH1611@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1104140920110.24613@xanadu.home>
 <20110414153813.GC6259@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110414153813.GC6259@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 14, 2011 at 04:38:14PM +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 14, 2011 at 09:39:58AM -0400, Nicolas Pitre wrote:
> Now, the next thing is that Linus hasn't been too happy about driver stuff
> coming via my tree either - it's something which has been the subject of
> concern in private email.  I've _already_ said something about that prior
> to the recent merge window.  So should I take the clk API stuff which
> touches the drivers subtree?  If yes, it needs to be kept entirely separate
> from the rest of the ARM stuff so we don't end up mixing drivers stuff with
> ARM stuff.
OK, so the solution is to put this in a seperate branch. But then when
platform maintainers start working with it the resulting changes will
most probably go to arch/arm. So if Linus doesn't want to pull a tree
that touches both drivers/clk and arch/arm, then either he has to pull
the clk branch first or we have to wait for the next merge window until
we can use it.

I prefer the former.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
