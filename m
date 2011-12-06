Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1LFSab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:30:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1LFSa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:30:29 -0500
Date: Tue, 6 Dec 2011 19:28:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206182847.GB12094@elte.hu>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <1323193731.32012.81.camel@twins>
 <20111206175558.3215907c@lxorguk.ukuu.org.uk>
 <20111206175919.GA5386@elte.hu>
 <20111206181715.GG3366@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206181715.GG3366@decadent.org.uk>
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


* Ben Hutchings <ben@decadent.org.uk> wrote:

> > What Peter did was rather sensible: he split a patch that 
> > did two things into two and applied one standalone, 
> > uncontroversial half of it and kept the part of the part of 
> > the changelog that related to that change.
> [...]
> 
> I can accept that if the change from my submission is 
> commented in the commit message.  (I sometimes do that with 
> other people's patches.)  But this was modified without 
> comment.

That was not what you requested though:

> > > > > If you disagree with a patch, do not silently drop 
> > > > > parts of it.  I demand that you remove my 
> > > > > 'Signed-off-by' as this is not the change I submitted.

What happened is that you did two things in a single patch and 
Peter applied the uncontroversial, unrelated bits in full.

> Giving credit for authorship is important, but it is also 
> important not to say someone is the sole author of something 
> when they aren't and haven't approved the subsequent changes 
> (cf. Alan Smithee).

It's all hunks submitted by you, you are the only author.

He did not modify your changes - you submitted several changes. 

You are actually the sole author of those changes in the commit. 
Peter only split up your original patch - he was actually being 
very constructive and 100% helpful with upstreaming your debug 
printout changes - which makes your original objection doubly 
offensive.

Thanks,

	Ingo
