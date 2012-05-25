Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929Ab2EYNMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:12:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11192 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab2EYNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:12:08 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=j3XDdUVUfX4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=hKBr1Bqb0r9Rr7fjuQoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337951526.13348.249.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dario Faggioli <raistlin@linux.it>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Fri, 25 May 2012 09:12:06 -0400
In-Reply-To: <1337946769.9783.189.camel@laptop>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
	 <1337331395.573.3.camel@twins>
	 <CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
	 <1337366237.573.106.camel@twins>
	 <CAMbhsRRnweLW_J+aBUsSbBh_Rp-PzVFap1FaRV1t9G0o9fZZAw@mail.gmail.com>
	 <1337433062.7075.9.camel@Abyss>
	 <CAMbhsRQYgOQA7NB-mdMDi8GxtTaZDQhED2J2X9YmyiYjAzXx4w@mail.gmail.com>
	 <1337779944.27368.94.camel@Solace> <1337946769.9783.189.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 13:52 +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 15:32 +0200, Dario Faggioli wrote:
> > Again, I really think it is the intended behaviour, and yes, real-time
> > group scheduling "breaks" the POSIX specification of the SCHED_{FIFO,RR}
> > policies intentionally (and _proudly_, as Peter would say it, am I
> > wrong? :-P). 
> 
> No, cgroups are well outside of POSIX ;-) as is SMP in fact.

That's because the POSIX standards committee is still struggling to come
up with standardized SMP calls to handle NR_CPUS = 0

Isn't Paul on that committee? ;-)

-- Steve


