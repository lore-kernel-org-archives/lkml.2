Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1DBSnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 14:43:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46336 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab1DBSnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 14:43:49 -0400
Date: Sat, 2 Apr 2011 20:43:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: sedat.dilek@gmail.com, Florian Mickler <florian@mickler.org>,
        Paul Bolle <pebolle@tiscali.nl>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, zersaa@gmail.com,
        stable@kernel.org
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics are
 not present
Message-ID: <20110402184314.GA17191@elte.hu>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
 <1301561386.1904.15.camel@t41.thuisdomein>
 <20110331125305.1e8c70ba@schatten.dmk.lab>
 <AANLkTikmWDu7FZ2A7_CWGCuAeKOeK4x+u8vctCro0mSN@mail.gmail.com>
 <m1ipuzfqb9.fsf@fess.ebiederm.org>
 <20110331124327.GA20112@elte.hu>
 <m1vcyxeavf.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vcyxeavf.fsf@fess.ebiederm.org>
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> >> I don't have a clue why my patch got lost, [...]
> >
> > It was not lost, it broke the build. You were notified but never followed up 
> > with a working patch:
> >
> >   https://lkml.org/lkml/2010/10/2/91
> >
> > and a different patch was applied to get rid of the warning messages. We can 
> > apply your patch (and that patch can undo the other fix), but it has to build, 
> > obviously.
> 
> Ingo any clue why I this message didn't make it to me directly but I
> only received it through the linux-kernel?

Hm, no idea - i did not receive any email bounce message.

Did you get this one directly?

Thanks,

	Ingo
