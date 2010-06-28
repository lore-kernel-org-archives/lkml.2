Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0F1PfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:35:09 -0400
Received: from www.tglx.de ([62.245.132.106]:40352 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab0F1PfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:35:06 -0400
Date: Mon, 28 Jun 2010 17:33:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Schwab <schwab@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Darren Hart <dvhltc@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Danny Feng <dfeng@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: Q: sys_futex() && timespec_valid()
In-Reply-To: <m3fx07rx9i.fsf@hase.home>
Message-ID: <alpine.LFD.2.00.1006281732460.2530@localhost.localdomain>
References: <alpine.LFD.2.00.1006252140410.18683@localhost.localdomain> <235959492.961541277496281970.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <AANLkTilaOOlzS2cJXCJF8Qn_cqjr7ywUv9RUTSsK9pf3@mail.gmail.com> <m3fx07rx9i.fsf@hase.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Andreas Schwab wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > We know it's not a valid absolute timeout, since there's no way
> > somebody is "waiting" for something that happened in the sixties.
> 
> Should it reject timestamps from the seventies?

No, because that's in the _VALID_ range of CLOCK_REALTIME and tv_sec
is >= 0. So we are nice to the post flower power folks.

Thanks,

	tglx
