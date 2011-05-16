Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1EPSrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:47:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51059 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1EPSr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:47:29 -0400
Subject: Re: linux-next: manual merge of the tip tree with the arm tree
From: John Stultz <john.stultz@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
In-Reply-To: <20110516113707.GQ30539@n2100.arm.linux.org.uk>
References: <20110513083738.GA19733@n2100.arm.linux.org.uk>
	 <20110513092646.GK13647@elte.hu>
	 <20110513213640.GB30539@n2100.arm.linux.org.uk>
	 <20110516073144.GF24836@elte.hu>
	 <20110516074230.GI30539@n2100.arm.linux.org.uk>
	 <20110516091744.GB12325@elte.hu>
	 <20110516091927.GK30539@n2100.arm.linux.org.uk>
	 <20110516094056.GA25039@elte.hu>
	 <20110516100750.GN30539@n2100.arm.linux.org.uk>
	 <20110516110652.GC19837@elte.hu>
	 <20110516113707.GQ30539@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 11:47:06 -0700
Message-ID: <1305571626.2915.24.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 12:37 +0100, Russell King - ARM Linux wrote:
> Obviously I shouldn't have added John's ack, which was sent during Monday
> nighttime to the commit so quickly, but instead waited a week before doing
> so.  Had I done that you wouldn't be complaining about "24 hours" or "18
> hours".

Yea, so its unfair for Russell to be taking all the heat on this one. 

I acked it, and I should have caught this issue. Part of the reason for
that is because my base for testing things is usually linus' tree, and
not tip.

Also the clocksource_register_hz/khz patches in tip (which also includes
Russell's "clocksource name const" patch) have been taking forever to
get upstream. They are low priority non-critical cleanups at this point,
so that's ok, but the original pull request for those was in Feb. And
the slower those sorts of things take to get upstream, the bigger the
window is for a collision.

So I'll try to be more proactive about grabbing and queuing such fixes
against the appropriate tip branch so that we can catch these issues,
and ideally the related patches properly move through their proper
maintainer tree.

At the same time, having recently done some similar consolidation work
in the RTC tree, as well as in the past the various clocksource work,
splitting up such changes across a number of different maintainers can
be a painfully slow process. This case isn't so bad because it was only
three spots, but I can understand if you don't see your patches pulled
into various maintainer trees quickly, you might use your normal
upstream route to get them in. Maybe it was a little too quick this
time, but I'm somewhat sympathetic to it.


thanks
-john








