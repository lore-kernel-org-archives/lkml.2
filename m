Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1HaCDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 22:03:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35658 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1HaCDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 22:03:35 -0400
X-Authority-Analysis: v=1.1 cv=hYZYwEn6AKazWLoXuCKKTQjUqAdcGu6fIqD+Oh7rMYo= c=1 sm=0 a=g0gqlliH0UYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=oB47_w9H01P2ocuC7RAA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] trace: change CPU ring buffer state from
 tracing_cpumask
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAL26m8KPDHPbad5y5ZYm4vY6i5TcgJ+tZSsT=r709dS9jX290Q@mail.gmail.com>
References: <1311210299-12607-1-git-send-email-vnagarnaik@google.com>
	 <CAL26m8KPDHPbad5y5ZYm4vY6i5TcgJ+tZSsT=r709dS9jX290Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 30 Aug 2011 22:03:32 -0400
Message-ID: <1314756212.21100.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 18:07 -0700, Vaibhav Nagarnaik wrote:
> >        arch_spin_unlock(&ftrace_max_lock);
> 
> Hi Steve
> 
> What do you think about this patch?

I'm fine with it. I'll see if I can add it to my 3.2 queue. I'm still
looking at some of your other patches you sent.

I'm still in the process of getting back into the swing of things as I
just came back from vacation :)

-- Steve


