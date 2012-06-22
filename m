Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2FVKso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:48:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab2FVKsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:48:43 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=f0KeEWH88hvQ8RiIHwgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340362121.27036.227.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        AndrewMorton <akpm@linux-foundation.org>
Date: Fri, 22 Jun 2012 06:48:41 -0400
In-Reply-To: <1340353448.31821.0.camel@joe2Laptop>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <1340353448.31821.0.camel@joe2Laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 01:24 -0700, Joe Perches wrote:
> On Thu, 2012-06-21 at 19:52 -0400, Steven Rostedt wrote:
> > Fengguang Wu had a config that caused the system to lockup. It reported:
> []
> 
> It'd have been nicer if you'd have cc'd me.

I didn't mean to be rude. I had pulled in my original patch which kept
the Cc list, and did a git --amend after making my changes and testing.
I just did a cut and paste to put back the Cc list.

> 
> What I submitted is far simpler and it allows a knob
> to control the printk buffering on a global basis.

But it did not handle the \n nor the timestamp prefix.

> 
> Did you try it?

No, because it did not do what I needed.

>   It seems to work here, but I don't
> have your other patches to rcu-torture with inserted
> printk_flush patches to verify it.  Can I have a
> copy of those please.

I just posted the places that I add it. There may be more places coming
too.

-- Steve

