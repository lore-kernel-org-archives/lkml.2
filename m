Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab1FJUoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:44:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:38429 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756244Ab1FJUoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:44:17 -0400
Message-ID: <4DF28274.3000708@suse.cz>
Date: Fri, 10 Jun 2011 22:45:40 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: maximilian attems <max@stro.at>, Ray Lee <ray-lk@madrabbit.org>,
        Arnaud Lacombe <lacombar@gmail.com>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild fixes for 3.0
References: <20110609214241.GA4849@sepie.suse.cz> <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com> <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com> <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com> <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com> <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com> <BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com> <BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com> <20110610100339.GE22466@vostochny.stro.at> <BANLkTin+RBL9aYzWeTBZ2Fj_m+8WuA_Ckg@mail.gmail.com>
In-Reply-To: <BANLkTin+RBL9aYzWeTBZ2Fj_m+8WuA_Ckg@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 10.6.2011 17:22, Linus Torvalds napsal(a):
>  - if no such work-arounds can be done without excessive hackery, at
> least make sure that the packages in question know that they are
> broken, so that they get fixed and we can drop the third digit later
> even if we don't drop it at 3.0 itself.

So can we fix the kernel package now, even if the version has to stay at
3.0.0? The depmod hack is probably superfluous, but the rest are either
cleanups or fixes to make a future NUM.NUM release:

      kbuild: Fix KERNELVERSION for empty SUBLEVEL or PATCHLEVEL
      kbuild: Fix <linux/version.h> for empty SUBLEVEL or PATCHLEVEL
      kbuild: Move depmod call to a separate script
      perf: Use make kernelversion instead of parsing the Makefile

and this one is a genuine regression fix:

      kbuild: silence Nothing to be done for 'all' message

So would pull the branch if I revert "kbuild: Hack for depmod not
handling X.Y versions"?

thanks,
Michal
