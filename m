Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab1EKRIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:08:20 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:50546 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1EKRIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:08:13 -0400
Date: Wed, 11 May 2011 16:15:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] sched: fix constructing the span cpu mask of sched domain
Message-ID: <20110511141509.GB19053@elte.hu>
References: <BANLkTi=qPWxRAa6+dT3ohEP6Z=0v+e4EXA@mail.gmail.com>
 <1305016329.2914.22.camel@laptop>
 <BANLkTin5iNMt2autv3TJpCvTQUoKsSzhTA@mail.gmail.com>
 <1305122055.2914.220.camel@laptop>
 <BANLkTikShtNvCcz5hfm5kgUwBwS1LqF9xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikShtNvCcz5hfm5kgUwBwS1LqF9xg@mail.gmail.com>
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


* Hillf Danton <dhillf@gmail.com> wrote:

> On Wed, May 11, 2011 at 9:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2011-05-11 at 21:26 +0800, Hillf Danton wrote:
> >> Your work for rewriting NUMA support, published at
> >>          http://marc.info/?l=linux-kernel&m=130218515520540
> >> is patched by changing how level is computed and by changing how it is
> >> used to build the mask.
> >>
> >> When computing, some valid levels are lost in your work.
> >>
> >> When building mask, nodes are selected only if they have same distance,
> >> thus nodes of less distance are also masked out since the computation of
> >> level now is tough.
> >>
> >> Without MUNA hardware, I did not test the patch:(
> >
> > I do have a (tiny) NUMA box (2 nodes) but that actually booted with the
> > old code too, Andreas Hermann from AMD (CC'ed) is usually willing to
> > test such patches on somewhat larger systems. Please send a full patch
> > against tip/master for him to apply.
> >
> Oh my God, I am not good at playing game with git, already laughed by many
> guys on LKML. As you see, I delivered all works based on diff through 512K ADSL,
> things like "git clone" sounds really monstrous.
> 
> Would you please, Peter, teach me how to play git, since I want to do more?

Here's how you fetch the scheduler tree:

  http://people.redhat.com/mingo/tip.git/README

and here's the Kernel Hacker's Guide to Git:

  http://linux.yyz.us/git-howto.html

Thanks,

	Ingo
