Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab1EMR0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:26:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59904 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089Ab1EMR0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:26:24 -0400
Date: Fri, 13 May 2011 18:25:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the tip tree with the arm tree
Message-ID: <20110513172509.GC19733@n2100.arm.linux.org.uk>
References: <20110513131437.8999e8eb.sfr@canb.auug.org.au> <20110513080634.GA13647@elte.hu> <20110513083738.GA19733@n2100.arm.linux.org.uk> <20110513092646.GK13647@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513092646.GK13647@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:26:46AM +0200, Ingo Molnar wrote:
> Also note that there's also some pending changes in the x86 tree modifying
> arch/x86/kernel/i8253.c:
> 
>   b01cc1b0eae0: x86: Convert remaining x86 clocksources to clocksource_register_hz/khz
> 
> If you want to do any further change to this file you need to pull in this 
> change first or need to resolve the conflict in some other way.

I have been told by Linus on more than one occasion that Linus wants to
see exactly these kinds of merge conflicts, as it helps him track what's
going on.

He's made that point again recently during discussions with the ARM
community, and he's gone further to explicitly state that he does _not_
want these kinds of merge conflicts to be hidden from him.

So I really don't see what the issue here is - if Linus is happy _and_
wants to resolve trivial merge conflicts then there's no problem here.
It's probably a good thing that Linus does see the conflict so he gets
to know that at least some ARM folk _are_ looking at common things
across all architectures.
