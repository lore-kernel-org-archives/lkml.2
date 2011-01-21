Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1AUXXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:23:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:40734 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab1AUXX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:23:29 -0500
Subject: Re: Locking in the clk API
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Colin Cross <ccross@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <AANLkTimT+vfg9p4GSnn1jGW9r_gVom7xEUzMVJDscPg2@mail.gmail.com>
References: <201101111016.42819.jeremy.kerr@canonical.com>
	 <20110111031552.GJ3760@linux-sh.org> <4D3862DB.5000708@fluff.org>
	 <20110120185617.GI6335@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.00.1101201623480.8580@xanadu.home>
	 <AANLkTimwBruVgGQWs5NQG7U3PcF6RQHZ6Pd1hjxyGpcA@mail.gmail.com>
	 <4D3907BD.4040900@codeaurora.org>
	 <AANLkTik53zyXytvuAd5zK0_zExfQT3FmOgTr8BexmGeT@mail.gmail.com>
	 <alpine.LFD.2.00.1101211618170.8580@xanadu.home>
	 <20110121220238.GE23151@n2100.arm.linux.org.uk>
	 <AANLkTimT+vfg9p4GSnn1jGW9r_gVom7xEUzMVJDscPg2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Jan 2011 10:21:42 +1100
Message-ID: <1295652102.2148.314.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 14:28 -0800, Colin Cross wrote:
> Clocks that have a voltage dependency, or depend on a clock that has a
> voltage dependency, are non-atomic, everything else is atomic.  PLLs
> are atomic because they lock very fast (300 uS or 1ms) 

Some could argue that this is still way too slow for atomic context :-)

Cheers,
Ben.

