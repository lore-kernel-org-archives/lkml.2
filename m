Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1GLUaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:30:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41220 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1GLUaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:30:19 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=L0M2l6TC3hIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=CE-arMJ0I0PG-5MRDq0A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/3] ftrace: Add extend-notrace to not trace sub
 funcs of notrace funcs
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1310499943.2309.3.camel@laptop>
References: <20110712185131.698851699@goodmis.org>
	 <20110712190302.475833802@goodmis.org>  <1310499943.2309.3.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 12 Jul 2011 16:30:16 -0400
Message-ID: <1310502616.3931.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 21:45 +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 14:51 -0400, Steven Rostedt wrote:
> > Known issues: Things that are called from assembly are also not traced.
> 
> We could of course create a gasm CALL macro that adds the mcount hookery
> and use that for those functions.

Hmm, that wouldn't be too hard to do. I'll go write up some patches.


> 
> /me runs

/me chases



