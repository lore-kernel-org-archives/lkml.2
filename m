Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2ITWr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:47:29 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:60617 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab2ITWr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:47:27 -0400
Date: Thu, 20 Sep 2012 22:47:25 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
In-Reply-To: <20120920220130.GN2449@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
References: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com> <20120913011208.GT4257@linux.vnet.ibm.com> <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com> <20120920000351.GI2455@linux.vnet.ibm.com> <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
 <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com> <20120920220130.GN2449@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Paul E. McKenney wrote:

> On Thu, Sep 20, 2012 at 09:49:13PM +0000, Bruce, Becky wrote:
>
> > OK, people, you can stop heckling me about "sent from my iPhone" - I'm in the wilds of rural Louisiana with really bad internet service and was trying to work on my phone (but, alas, did not notice the CC list included the entire universe).   Shame on me.
> > 
> > With the above set, I don't seem to see any stalls with the RCU timeout set to 60s (the default).  I left the board running for 25 minutes; I will fire it up again later and let it run for a bit longer, but usually I end up seeing the problem pretty quickly so I don't expect that to result in anything.  I also didn't see any stalls on Paul's RCU tree as of a week ago at 60s, so as far as I can tell the CPU_IDLE stuff didn't have any impact (it wasn't on when I tested Paul's tree).
> > 
> > If I drop the timeout to 5s as Paul M. suggested for debug a while back, I do see stalls (both with CPU_IDLE stuff and without). 
> > 
> > I'm using the default omap2plus config, with RCU stall info enabled and the cpu idle stuff turned on (console dump below).  This is a Panda ES 1.1 (OMAP4460)
> 
> Thank you for the testing, Becky!
> 
> Paul Walmsley, please let me know if the config below doesn't clear things
> up for you or if there is some reason why this config is infeasible.

Will certainly test it here once things settle down.  But I wouldn't 
consider the use of CONFIG_CPU_IDLE to be a 'fix' until the problem can be 
understood.  We use !CONFIG_CPU_IDLE kernels for testing here.


- Paul
