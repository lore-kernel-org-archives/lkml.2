Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1HALB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:01:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55555 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1HALBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:01:50 -0400
Subject: Re: [ANNOUNCE] 3.0-rt6
From: Peter Zijlstra <peterz@infradead.org>
To: Rolando Martins <rolando.martins@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <CABcS5h0m10aWDuK5fK4C-mzMMwLyXJ_cehoTgWFutvPPrv30HQ@mail.gmail.com>
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
	 <CABcS5h0m10aWDuK5fK4C-mzMMwLyXJ_cehoTgWFutvPPrv30HQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 13:06:29 +0200
Message-ID: <1312196789.2617.447.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 09:42 +0100, Rolando Martins wrote:
> Hi Peter,
> is there any progress on the CONFIG_RT_GROUP_SCHED front?
> I don't know if this is related, but in 33-rt if I used a low (=100)
> cpu_runtime_us and cpu_period_us then I would get some freezes
> (something that does not happen in 2.6.39).
> 
> 
No, I've been busy mopping up other things.. Ideally I'd rip out all the
current rt group code and put int the stuff Dario and Fabio are working
on, sadly they too are otherwise engaged atm.

I'll see if I can find a bit of time this week to stare at this mess.

