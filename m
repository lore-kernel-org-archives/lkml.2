Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1DTQlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:41:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:40360 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab1DTQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:41:17 -0400
Date: Wed, 20 Apr 2011 18:41:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Paul Mundt <lethal@linux-sh.org>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
In-Reply-To: <20110420142816.GZ31131@pengutronix.de>
Message-ID: <alpine.LFD.2.02.1104201830500.3323@ionos>
References: <1299134429.100626.661279191478.0.gpush@pororo> <1302754859.2767.30.camel@pororo> <20110414100048.GB1611@n2100.arm.linux.org.uk> <1302776705.28876.113.camel@pasglop> <20110414103200.GF1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140751220.24613@xanadu.home>
 <20110414120904.GH1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140920110.24613@xanadu.home> <20110414153813.GC6259@n2100.arm.linux.org.uk> <20110418105442.GB27864@linux-sh.org> <20110420142816.GZ31131@pengutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-63488165-1303317666=:3323"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-63488165-1303317666=:3323
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 20 Apr 2011, Uwe Kleine-König wrote:
> I declare this to be stable, so assuming people are OK with it, you can
> use that as a base to convert your platforms.

You declare that stable? Interesting.
 
> There is a 2nd branch on that repository that also contains my RFC patch
> just sent to this list in case you want to test it.

Which is utter crap as I pointed out a few minutes ago.

Also that clk thing is neither stable nor complete. It's just designed
wrong. 

As long as it does not handle nested clocks proper and by default w/o
your tasteless add ons, it's just moving the status quo of ARM into a
common infrastructure file.

Yes, that's probably better than not having common infrastructure at
all, but trying to build up conversions on that lot would be a
complete waste of time and resources. Simply because you need to
convert the already converted stuff another time.

Thanks,

	tglx
--8323328-63488165-1303317666=:3323--
