Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1CKGhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 01:37:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40719 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab1CKGhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 01:37:04 -0500
Date: Fri, 11 Mar 2011 07:36:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110311063649.GA13293@elte.hu>
References: <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
 <20110310.155556.48513201.davem@davemloft.net>
 <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
 <20110310.163434.260095615.davem@davemloft.net>
 <AANLkTimAPqTYT_j6t3cT32WfD6cQPySG0tnQVhC8Z=NO@mail.gmail.com>
 <20110311033406.GA11004@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311033406.GA11004@home.goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, Mar 10, 2011 at 04:51:34PM -0800, Linus Torvalds wrote:
> > 
> > The reasons can be any of:
> > 
> >  - "I don't want to get too far away from upstream". This is very
> > understandable, but I have asked people to please _not_ merge "random
> > trees of the day". Please use major releases for this (or, if worst
> > comes to worst, -rc releases) rather than just do something else.
> 
> What are you throughts on starting work from a tree. Most of my work is usually 
> based off of some branch in tip, but sometimes when I'm pulling in patches that 
> are not really related to anything, I just simply grab whatever the latest Linus 
> branch is and start from there.
> 
> Is it preferable to instead start from one of the official releases?

Yes, for clarity of merge history i'm generally asking all people who send pull 
requests to -tip to use official -rc's as bases (or -tip branches), *not* some 
random daily -git snapshot. If a -git snapshot has to be merged for a good reason 
then please amend the merge commit with the Merge-Reason tag describing the good 
reason you had.

Thanks,

	Ingo
