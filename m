Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0F1Pab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:30:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab0F1Pa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:30:28 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: Q: sys_futex() && timespec_valid()
References: <alpine.LFD.2.00.1006252140410.18683@localhost.localdomain>
	<235959492.961541277496281970.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<AANLkTilaOOlzS2cJXCJF8Qn_cqjr7ywUv9RUTSsK9pf3@mail.gmail.com>
X-Yow: Uh-oh!!  I'm having TOO MUCH FUN!!
Date: Mon, 28 Jun 2010 17:29:29 +0200
In-Reply-To: <AANLkTilaOOlzS2cJXCJF8Qn_cqjr7ywUv9RUTSsK9pf3@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 28 Jun 2010 08:15:26 -0700")
Message-ID: <m3fx07rx9i.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> We know it's not a valid absolute timeout, since there's no way
> somebody is "waiting" for something that happened in the sixties.

Should it reject timestamps from the seventies?

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
