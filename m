Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1C1XD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:03:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:45545 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1C1XD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:03:26 -0400
Date: Tue, 29 Mar 2011 01:03:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snizer@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Regression] Please revert a91a2785b20
In-Reply-To: <yq1hbamkgoe.fsf@sermon.lab.mkp.net>
Message-ID: <alpine.LFD.2.00.1103290049330.2774@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6> <yq1hbamkgoe.fsf@sermon.lab.mkp.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Martin K. Petersen wrote:
> >>>>> "Thomas" == Thomas Gleixner <tglx@linutronix.de> writes:
> 
> Thomas,
> 
> Thomas> But the changelog does not give the courtesy of explaining these
> Thomas> changes. Also there is no fcking reason why the kernel cannot
> Thomas> deal with the missing integrity capabilities of a drive just by
> Thomas> emitting a warning msg and dealing gracefully with the outcome.
> 
> My mistake. I was made aware of it earlier today and I'm working on a

Why didn't you send a revert to Linus right away?

Darn. I sent a pull request earlier today, which I immediately
revoked, when I noticed that it had a late reported testing
failure. It did not hit Linus public tree fortunately. I could have
said "I'm working on a fix" as well. But that's the wrong thing to do.

So for your thing, it was already in Linus tree. Though if you get
aware of it and it's revertable w/o creating lots of mess, then it's
the right thing to revert it immediately. Do not drag out regressions
longer than necessary, please.

> Surprised we didn't see any reports of this in -next. It's been
> in there for a while.

next does unfortunately get not the full exposure and it's neither a
replacement for common sense nor an excuse for not testing the common
case (i.e. non enterprise hardware with default distro configs)

Thanks,

	tglx
