Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0EJClP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 22:41:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:37522 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab0EJClN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 22:41:13 -0400
Subject: Re: [PATCH -v14 00/22] Use lmb with x86
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 12:38:59 +1000
Message-ID: <1273459139.23699.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-08 at 08:17 -0700, Yinghai Lu wrote:
> the new lmb could be used to replace early_res in x86.
> 
> Suggested by: David, Ben, and Thomas

 .../...

> Only first three patches in this set could affect original lmb users.
> lmb.c lines from 567 to 996
> If lmb guys are still not happy, we could move that 360 lines to arch/x86/mm/lmb.c
> 
> still hope Ben could do lmb clean up on top of this patchset.

I would still like to do it the other way around :-)

My patches replace (and in some case are equivalent) to part of this
series, though I believe are cleaner, provide more readable changeset
comments and justifications, etc... it would be awkward to just apply
your stuff with "cleanup" passes from me on top of it.

I really prefer providing you with all the LMB infrastructure you need
so you can simply drop LMB changes from your series.

I'll be working on that today, finishing what I plan to finish and if I
get a chance (it's hard with one of the kids having a double ear
infection) see if I can rebase your work and at least compile test it.

Stay tuned...

Cheers,
Ben.


