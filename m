Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1HALK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:10:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49268 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1HALKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:10:03 -0400
MIME-Version: 1.0
In-Reply-To: <1312196789.2617.447.camel@laptop>
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
	<CABcS5h0m10aWDuK5fK4C-mzMMwLyXJ_cehoTgWFutvPPrv30HQ@mail.gmail.com>
	<1312196789.2617.447.camel@laptop>
Date: Mon, 1 Aug 2011 12:10:01 +0100
Message-ID: <CABcS5h3rrWVf37nQHqVQEcbtkwX418ckqee74Qc9Oxts+U+qEg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt6
From: Rolando Martins <rolando.martins@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 12:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-08-01 at 09:42 +0100, Rolando Martins wrote:
>> Hi Peter,
>> is there any progress on the CONFIG_RT_GROUP_SCHED front?
>> I don't know if this is related, but in 33-rt if I used a low (=100)
>> cpu_runtime_us and cpu_period_us then I would get some freezes
>> (something that does not happen in 2.6.39).
>>
>>
Hi Peter,

> No, I've been busy mopping up other things.. Ideally I'd rip out all the
> current rt group code and put int the stuff Dario and Fabio are working
> on, sadly they too are otherwise engaged atm.
So, we would have sched_deadline support in rt? That would be amazing!

>
> I'll see if I can find a bit of time this week to stare at this mess.
Ok! I hope to contribute to the effort at least by providing some testing...

Thanks,
Rolando

>
>
