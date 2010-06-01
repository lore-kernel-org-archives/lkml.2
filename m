Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0FAGfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:35:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58219 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab0FAGfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:35:41 -0400
Date: Tue, 1 Jun 2010 08:35:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: tytso@mit.edu, Alex Buell <alex.buell@munted.org.uk>,
       Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35 release
 candidates
Message-ID: <20100601063532.GA30305@elte.hu>
References: <1275347969.29006.5.camel@lithium.local.net>
 <20100601041028.GB4426@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601041028.GB4426@thunk.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tytso@mit.edu <tytso@mit.edu> wrote:

> On Tue, Jun 01, 2010 at 12:19:29AM +0100, Alex Buell wrote:
> > http://www.phoronix.com/vr.php?view=14976
> > 
> > Question: Why?
> 
> One of the theories that has been advanced is that it's simply this problem:
> 
> 	http://lkml.org/lkml/2010/5/22/154
> 
> If so, it points out how idiotic Phoronix is about not being able to notice 
> udev pegging the CPU at 100% being someone bad for its benchmark runs.  :-)

They might be 'minimally helpful' and they might want to maximize clicks, but 
IMO that doesnt equate to 'idiotic', at all. The slowdown was real and they 
have no obligation to figure out what caused it.

Think what an ordinary tester would do: install -rc1, see a slowdown, skip 
back to v2.6.34. Reporting the 'macro performance' metrics is useful.

As Linux gets more and more mainstream we should get used to 
selfish/hostile/unhelpful journalism, just like we had to get used to 
selfish/hostile/unhelpful users, developers, etc. This isnt directed at Linux, 
this is simply an unavoidable side effect of becoming more mainstream. And 
there will be more of this, hopefully ;-)

Thanks,

	Ingo
