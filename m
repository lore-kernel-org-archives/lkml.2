Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1FGLBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:01:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab1FGLBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:01:10 -0400
Date: Tue, 7 Jun 2011 13:01:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: random hangs during boot in 3.0-rc
Message-ID: <20110607110102.GE21356@elte.hu>
References: <20110607034617.GA27980@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607034617.GA27980@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> I have two machines that occasionally (like 1 in 10 boots or so) 
> hang solid during boot-up.  Happens in different places, but 
> usually either when loading the microcode driver, or while doing a 
> fsck.

I think this commit in tip:sched/urgent will fix it:

  f2513cde93f0: lockdep: Fix lock_is_held() on recursion

Will send it to Linus later today.

Thanks,

	Ingo
