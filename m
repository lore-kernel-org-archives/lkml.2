Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab1GYMKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:10:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1GYMJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:09:56 -0400
Date: Mon, 25 Jul 2011 14:09:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725120903.GA11952@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725103817.GA21683@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725103817.GA21683@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jul 25, 2011 at 10:14:13AM +0200, Alexander Graf wrote:

> > So instead of thinking a bit and trying to realize that there 
> > might be a reason people don't want all their user space in the 
> > kernel tree you go ahead and start your own crusade of creating a 
> > new user space. Great. That's how I always hoped Linux would be 
> > :(.
> 
> It's not Linux in general yet, it's mostly a crusade of a few with 
> a political agenda.

I find it weird (and insulting) that you are calling our patches that 
implement better tolling a 'crusade' done under a 'political agenda'.

I'd rather say that the extremist position is yours: to keep 
everything separated always, all the time and ban tools from the 
kernel repo.

You have declared it a failure from the very start and if it were up 
to you it would never get a fair chance.

Thanks,

	Ingo
