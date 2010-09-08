Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0IHP75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:59:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab0IHP7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:59:55 -0400
X-Authority-Analysis: v=1.1 cv=2UVid5d+x37NY9sg6AthlbJk7luIC5bYp3eyRq7Iv0o= c=1 sm=0 a=CmmInZBHP1oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=xn_2uDM6AAAA:8 a=20KFwNOVAAAA:8 a=hQmCWiDBLtKAQLFpSpgA:9 a=arnyM-jhh3xYh0tJb9t7Rcx7x0cA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=AlnqcuNMsHEA:10 a=jEp0ucaQiEUA:10 a=oUQuMaGMe1cA:10 a=LI9Vle30uBYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL][v2.6.36 & stable] tracing: Do not allow
 llseek to set_ftrace_filter
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Swiecki <swiecki@google.com>,
        Chris Wright <chrisw@sous-sol.org>, Tavis Ormandy <taviso@google.com>,
        Eugene Teo <eugene@redhat.com>, vendor-sec <vendor-sec@lst.de>,
        stable@kernel.org
In-Reply-To: <1283961195.5133.140.camel@gandalf.stny.rr.com>
References: <1283961195.5133.140.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 08 Sep 2010 11:59:52 -0400
Message-ID: <1283961592.5133.141.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 11:53 -0400, Steven Rostedt wrote:
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:

Wait! Don't pull!!!

> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
>     
>     Reported-by: Robert Swiecki <swiecki@google.com>
>     Cc: Chris Wright <chrisw@sous-sol.org>
>     Cc: Tavis Ormandy <taviso@google.com>
>     Cc: Eugene Teo <eugene@redhat.com>
>     Cc: vendor-sec@lst.de
>     Cc: <stable@kernel.org>
>     Signed-off-by: root <root@ixf.(none)>
> 

I've could have sworn I set up this machine. Bah! I think I reinstalled
it. :-p

/me goes and fixes it.

Thanks Frederic ;-)

-- Steve


