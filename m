Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1LOHKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:10:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1LOHKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:10:47 -0500
Date: Thu, 15 Dec 2011 08:08:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] sched: mark parent and real_parent as __rcu
Message-ID: <20111215070857.GD14237@elte.hu>
References: <20111214223925.GA27578@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214223925.GA27578@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> The parent and real_parent pointers should be considered __rcu, since
> they should be held under either tasklist_lock or rcu_read_lock.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/sched.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Did you get some warning that alerted you to this problem? If 
yes then please include it in the changelog, so that people 
hitting the message can easily find it.

Same consideration applies the second patch as well.

Thanks,

	Ingo
