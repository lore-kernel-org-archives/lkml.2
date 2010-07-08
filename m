Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0GHUo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:44:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:49791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0GHUo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:44:27 -0400
Subject: Re: high power consumption in recent kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Norbert Preining <preining@logic.at>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>,
       tglx <tglx@linutronix.de>
In-Reply-To: <1278618040.7498.21.camel@marge.simson.net>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	 <1278579992.1900.17.camel@laptop> <20100708045711.398d4e26@infradead.org>
	 <1278590303.1900.91.camel@laptop>
	 <20100708120421.GF20841@gamma.logic.tuwien.ac.at>
	 <1278591779.1900.97.camel@laptop>
	 <20100708124627.GA7754@gamma.logic.tuwien.ac.at>
	 <1278595426.1900.130.camel@laptop>  <1278604779.1900.157.camel@laptop>
	 <1278618040.7498.21.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 22:44:14 +0200
Message-ID: <1278621854.1900.188.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 21:40 +0200, Mike Galbraith wrote:
> > Mike could you re-run your netperf tests that showed the 10% throughput
> > gain? Hopefully the fixed governor will yield the same result and we can
> > kill off this ratelimit thing.
> 
> The gain is (well was last time I checked), but as noted, I'd just call
> it a misguided optimization and be done with it. 

It would still be good to know what your machine does, if you can still
see a difference there might still be something to look at.

