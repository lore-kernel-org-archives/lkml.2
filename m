Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1CICMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:12:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41959 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab1CICMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:12:16 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=KpzchuzAFZgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=CyU-fdax1AOE9ngZ2vIA:9 a=xt50koO7gG9WnZ06q_uh6Ig1RjcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
From: Steven Rostedt <rostedt@goodmis.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        chris <chris@chris-wilson.co.uk>
In-Reply-To: <20110309020131.GA19224@yliu-dev.sh.intel.com>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
	 <20110308232258.GA25987@Krystal>
	 <1299627175.20306.96.camel@gandalf.stny.rr.com>
	 <20110309000753.GA27729@Krystal>
	 <1299629657.20306.105.camel@gandalf.stny.rr.com>
	 <20110309002921.GA744@Krystal>
	 <1299631924.20306.122.camel@gandalf.stny.rr.com>
	 <20110309020131.GA19224@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 21:12:14 -0500
Message-ID: <1299636734.20306.134.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 10:01 +0800, Yuanhan Liu wrote:

> > Users are for testing code ;)
> 
> As another end-user, this looks fine (also simple) to me ;)

Ah, you find this patch I have simple?

> 
> > 
> > But that's a good question. As I wrote this because I'm purging my inbox
> > and came across Yuanhan Liu's patch set. I'm curios to what Yuanhan's
> > motivation for this change was.
> 
> The motivation of my original patch is simple: try to not miss any trace
> events. I guess it's a kind of feature that trace(or module) should
> have ;) 

Hmm, I probably could add a trace option that simply tells ftrace to
enable events as modules are loaded.

Thanks!

-- Steve


