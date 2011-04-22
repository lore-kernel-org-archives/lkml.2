Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1DVCes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 22:34:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1DVCer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 22:34:47 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=R6sLeq5vHiIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=onNMdJFufQovcYhef7cA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <BANLkTikBk2n8x1gJBHHrpxZZrhEpVFxt4A@mail.gmail.com>
References: <20110421014153.126662477@goodmis.org>
	 <20110421014259.132728798@goodmis.org>
	 <BANLkTimzhTqOXZ6BFGP68EB4Wqrx9OAH7Q@mail.gmail.com>
	 <1303386029.7181.118.camel@gandalf.stny.rr.com> <20110421133541.GB2702@zhy>
	 <1303395845.7181.127.camel@gandalf.stny.rr.com>
	 <BANLkTikBk2n8x1gJBHHrpxZZrhEpVFxt4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Apr 2011 22:34:44 -0400
Message-ID: <1303439684.7181.150.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 09:41 +0800, Yong Zhang wrote:

> > I probably should modify the lockdep selftests to add an option to show
> > the output as well as it triggers errors. This would allow me to make
> > sure the output still works.
> 
> This does make sense to keep things consistent if we have it.

Actually, Peter informed me that we already do this. Just need to boot
with debug_locks_verbose=1.

> 
> >
> > But for now, I have other things to work on ;)
> 
> If you want, you can show more details on your ideas,
> maybe I could get some time to finish it :)

Well, I got pretty much what I wanted out for now. I'll probably go and
look later. But by all means, if you find other ways to make lockdep
more readable. Please, don't let me stop you ;)

-- Steve



