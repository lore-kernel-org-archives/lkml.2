Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab0IXWNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:13:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:41114 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab0IXWNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:13:10 -0400
Subject: Re: [PATCH 1/8] posix clocks: introduce a syscall for clock tuning.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linuxppc-dev@lists.ozlabs.org,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <20100924075534.GB5043@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
	 <b94ef1cd9c04ef3ad5964408bd0af7251add78de.1285261534.git.richard.cochran@omicron.at>
	 <1285279423.5158.20.camel@pasglop>
	 <20100924075534.GB5043@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 08:12:20 +1000
Message-ID: <1285366340.14081.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > This list is getting way too much unrelated stuff, which I find
> > annoying, it would be nice if we were all a bit more careful here with
> > our CC lists.
> 
> Sorry, I only added device-tree because some one asked me to do so.
> 
>     http://marc.info/?l=linux-netdev&m=127273157912358
> 
> I'll leave it off next time.

That's allright. I'd rather you just post the bindings there than the
whole patch least but no big deal.

I was just fixing my email filters and notice a lot of seemingly
unrelated stuff landing there :-)

Cheers,
Ben.

