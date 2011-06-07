Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1FGPnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:43:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1FGPnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:43:05 -0400
X-Authority-Analysis: v=1.1 cv=rr9DlE2fnT1UeYFJeFag6ks/js+bHNfqVlaSByoS2d4= c=1 sm=0 a=XYJHFtupD_QA:10 a=Nfqsw8rmjecA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4tPi0hnKUep1tSFEes4A:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 7 Jun 2011 11:43:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: correct testing need_resched in
 mutex_spin_on_owner()
Message-ID: <20110607154302.GD27245@home.goodmis.org>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
 <1307454439.2322.260.camel@twins>
 <BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
 <1307456680.2322.270.camel@twins>
 <BANLkTim1htraTXtGMcyAuH1Wa-G+J05i_g@mail.gmail.com>
 <1307457646.2322.273.camel@twins>
 <BANLkTi=XTpYTZvetOUDgobRa_S4Cb=+syA@mail.gmail.com>
 <1307460040.2322.279.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307460040.2322.279.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 05:20:40PM +0200, Peter Zijlstra wrote:
> 
> Please, get a grip on reality and stop sending endless streams of
> patches based on wrong assumptions and mis-understandings.

Hillf,

Some of your patches are good, but others are frivolous. It becomes a
burden on the maintainer to figure out which is which.

I've asked you to please back up your patches with tests and/or
benchmarks that clearly demonstrate what you are showing. I have yet to
see any of that. If you have trouble coming up with test cases it may be
because your assumptions about what is happening is incorrect.

If you just randomly send out a bunch of patches where the noise/signal
ratio is high, you will soon just be ignored. I don't want this
happening, as I stated, some of your patches are good. But when you
start to fight back and it becomes clear that you totally do not
understand what you are talking about, it becomes hard to take you
seriously.

-- Steve

