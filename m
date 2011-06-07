Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1FGSes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:34:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57642 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1FGSer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:34:47 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=Nfqsw8rmjecA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8mrF3ihsfxdIS2URd3EA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: correct testing need_resched in
 mutex_spin_on_owner()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTim-3qPKAbKfshhkVuBJcVoZKXFXQQ@mail.gmail.com>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
	 <1307454439.2322.260.camel@twins>
	 <BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
	 <1307456680.2322.270.camel@twins>
	 <BANLkTim1htraTXtGMcyAuH1Wa-G+J05i_g@mail.gmail.com>
	 <1307457646.2322.273.camel@twins>
	 <BANLkTi=XTpYTZvetOUDgobRa_S4Cb=+syA@mail.gmail.com>
	 <20110607150816.GC27245@home.goodmis.org>
	 <BANLkTim-3qPKAbKfshhkVuBJcVoZKXFXQQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Jun 2011 14:34:45 -0400
Message-ID: <1307471685.9218.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 02:22 +0800, Hillf Danton wrote:

> After hours chewing __mutex_lock_common() and mutex_spin_on_owner(),
> and what you and Peter said, the owner is on different CPU from the waiter,
> and the patched need_resched is simply meaning the waiter is no longer
> willing to wait for whatever reasons.
> 
> It is really unlucky tonight:(

Please don't get discouraged.

We just want you to spend a bit more time looking at the code. Do what I
do when something looks wrong. Try to figure out what the author was
doing and why it may actually be correct. You may find out that the code
is indeed correct.

When I see code that looks wrong, I first think my assumptions are
incorrect, and I try to prove myself wrong. Only when I fail to do that,
do I send a patch or bring it up to the author. And then, I do it in
such a way that the author of the code may still have the ability to
prove me wrong. And several times, an author will tell me something that
I overlooked, and the original code stays as is.

Don't take it personally, this is just a learning phase. ;)

-- Steve


