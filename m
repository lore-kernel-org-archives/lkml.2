Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab2EYLw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:52:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44991 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2EYLwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:52:55 -0400
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dario Faggioli <raistlin@linux.it>
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
In-Reply-To: <1337779944.27368.94.camel@Solace>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
	 <1337331395.573.3.camel@twins>
	 <CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
	 <1337366237.573.106.camel@twins>
	 <CAMbhsRRnweLW_J+aBUsSbBh_Rp-PzVFap1FaRV1t9G0o9fZZAw@mail.gmail.com>
	 <1337433062.7075.9.camel@Abyss>
	 <CAMbhsRQYgOQA7NB-mdMDi8GxtTaZDQhED2J2X9YmyiYjAzXx4w@mail.gmail.com>
	 <1337779944.27368.94.camel@Solace>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 13:52:49 +0200
Message-ID: <1337946769.9783.189.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 15:32 +0200, Dario Faggioli wrote:
> Again, I really think it is the intended behaviour, and yes, real-time
> group scheduling "breaks" the POSIX specification of the SCHED_{FIFO,RR}
> policies intentionally (and _proudly_, as Peter would say it, am I
> wrong? :-P). 

No, cgroups are well outside of POSIX ;-) as is SMP in fact.

