Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1DUOYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:24:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1DUOYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:24:07 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=R6sLeq5vHiIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ZRrO2wL-Emo26PX8APwA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/7] lockdep: Print a nice description of an irq
 locking issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110421133541.GB2702@zhy>
References: <20110421014153.126662477@goodmis.org>
	 <20110421014259.132728798@goodmis.org>
	 <BANLkTimzhTqOXZ6BFGP68EB4Wqrx9OAH7Q@mail.gmail.com>
	 <1303386029.7181.118.camel@gandalf.stny.rr.com> <20110421133541.GB2702@zhy>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Apr 2011 10:24:05 -0400
Message-ID: <1303395845.7181.127.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 21:35 +0800, Yong Zhang wrote:
> On Thu, Apr 21, 2011 at 07:40:29AM -0400, Steven Rostedt wrote:

> > I
> > could show the entire chain too.
> 
> Sure :)

I talked a little about this with Peter Zijlstra on IRC, and we agreed
that we'll keep this as is until we notice that kernel developers are
still confused with the output.

The more advanced I make this output, the more likely I'll make a
mistake and show something that is not what actually happens. I wrote a
module to trigger each of these cases and the problems that lockdep can
detect grows exponentially as we make the output more specific.

I probably should modify the lockdep selftests to add an option to show
the output as well as it triggers errors. This would allow me to make
sure the output still works.

But for now, I have other things to work on ;)

-- Steve


