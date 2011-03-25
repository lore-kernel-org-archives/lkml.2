Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1CYMw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:52:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63600 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1CYMw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:52:57 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=uL5GH6c9apcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=KUcdRaTsbh77NpmZl3MA:9 a=acA_bW-6awUXX_FVrCkiBnuOuvcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: leave sched_setscheduler earlier if possible.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <1301048910.2250.184.camel@laptop>
References: <1300971618.3960.82.camel@Palantir>
	 <1300976519.14261.141.camel@gandalf.stny.rr.com>
	 <1301048910.2250.184.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Mar 2011 08:52:53 -0400
Message-ID: <1301057573.14261.168.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 11:28 +0100, Peter Zijlstra wrote:
> On Thu, 2011-03-24 at 10:21 -0400, Steven Rostedt wrote:
> > > @@ -4998,6 +4998,16 @@ recheck:
> > 
> > Peter, this is why I prefer:
> > 
> >  recheck:
> > over
> > recheck:
> > 
> And you know I prefer to fix the tools ;-)

And when the tools are fixed, I'll also prefer

recheck:
over
 recheck:

;-)

-- Steve


