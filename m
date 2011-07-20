Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1GTFEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 01:04:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab1GTFEJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 01:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110720044435.GB2400@linux.vnet.ibm.com>
References: <20110720001738.GA16369@linux.vnet.ibm.com> <201107192130.02080.edt@aei.ca>
 <201107192207.33813.edt@aei.ca> <20110720044435.GB2400@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Jul 2011 22:03:05 -0700
Message-ID: <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads trainwreck
To: paulmck@linux.vnet.ibm.com
Cc: Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, greearb@candelatech.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 9:44 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Jul 19, 2011 at 10:07:32PM -0400, Ed Tomlinson wrote:
>> On Tuesday 19 July 2011 21:30:00 Ed Tomlinson wrote:
>> > On Tuesday 19 July 2011 20:17:38 Paul E. McKenney wrote:
>>
>> Paul,
>>
>> Two things to add.  Its possible an eariler error is missing from the log below.  My serial console was missing
>> entries from before '0 and 40ish' and I did think I saw a bunch of FFFFFFFs scroll by eariler...
>>
>> Second, booting with threadirqs and boost enabled in .config with patches 2,5,6 is ok so far.
>
> Patches 3 and 4 resulted in failures?  (Patch 1 certainly did.)

Gaah. Any possibility of getting this resolved soon?

I've merged the pathname lookup fix. I was hoping all the RCU issues
were behind us..

                    Linus
