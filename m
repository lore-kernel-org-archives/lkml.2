Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0KISza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:55:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0KISz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:55:29 -0500
Date: Tue, 9 Nov 2010 13:55:16 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, tmhikaru@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: High CPU load when machine is idle (related to PROBLEM:
 Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101109185516.GQ8332@bombadil.infradead.org>
References: <AANLkTin+HE09Oui89uCmG-rrHE14zXfJuRvZgsPCB1De@mail.gmail.com>
 <1287788622-25860-1-git-send-email-venki@google.com>
 <1288001573.15336.52.camel@twins>
 <1288097074.15336.211.camel@twins>
 <1288101958.15336.284.camel@twins>
 <1288381343.1988.12.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288381343.1988.12.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 09:42:23PM +0200, Peter Zijlstra wrote:
> 
> not tested other than compile, but how does that look...?
> 

Hi Peter,

I finally got around to building a test kernel for a user who had been
reporting this against F-14 (2.6.35) but they report there's not much
improvement.

Sorry. :/

<quote>
Date: Tue, 09 Nov 2010 12:46:53 -0600
From: Michael Cronenworth <mike@cchtml.com>
To: test@lists.fedoraproject.org
Subject: Re: Virtually impossible to keep load under 0.5 on idle desktop with
	F14+kms

On 11/09/2010 11:55 AM, Kyle McMartin wrote:
> http://kyle.fedorapeople.org/kernel/2.6.35.6-52.sched1.fc14/

Running this kernel is not any better. After leaving my system idle for 
10 minutes I finally saw it dip below 0.10, but after leaving the 
computer, and coming back 10 minutes later, I see a load of 0.25. No 
programs running.

Before I hit "send" on this message, I ran uptime again and got this:
$ uptime
  12:45:24 up 32 min,  3 users,  load average: 0.82, 0.43, 0.34

Thunderbird was the only program running. 99.8% idle.
</quote>

regards, Kyle
