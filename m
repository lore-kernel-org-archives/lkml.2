Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1KAVnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:43:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab1KAVnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:43:11 -0400
Date: Tue, 1 Nov 2011 14:43:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Message-Id: <20111101144309.a51c99b5.akpm@linux-foundation.org>
In-Reply-To: <f62e02cd-fa41-44e8-8090-efe2ef052f64@default>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	<20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
	<ef778e79-72d0-4c58-99e8-3b36d85fa30d@default
 20111101095038.30289914.kamezawa.hiroyu@jp.fujitsu.com>
	<f62e02cd-fa41-44e8-8090-efe2ef052f64@default>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011 08:25:38 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> OK, I will then coordinate with sfr to remove it from the linux-next
> tree when (if?) akpm puts the patchset into the -mm tree.

No, that's not necessary.  The current process (you maintain git tree,
it gets included in -next, later gets pulled by Linus) is good.  The
only reason I see for putting such code through -mm would be if there
were significant interactions with other core MM work.

It doesn't matter which route is taken, as long as the code is
appropriately reviewed and tested.

>  But
> since very few linux-mm experts had responded to previous postings
> of the frontswap patchset, I am glad to have a much wider audience
> to discuss it now because of the lkml git-pull request.

At kernel summit there was discussion and overall agreement that we've
been paying insufficient attention to the big-picture "should we
include this feature at all" issues.  We resolved to look more
intensely and critically at new features with a view to deciding
whether their usefulness justified their maintenance burden.  It seems
that you're our crash-test dummy ;) (Now I'm wondering how to get
"cgroups: add a task counter subsystem" put through the same wringer).

I will confess to and apologise for dropping the ball on cleancache and
frontswap.  I was never really able to convince myself that it met the
(very vague) cost/benefit test, but nor was I able to present
convincing arguments that it failed that test.  So I very badly went
into hiding, to wait and see what happened.  What we needed all those
months ago was to have the discussion we're having now.

This is a difficult discussion and a difficult decision.  But it is
important that we get it right.  Thanks for you patience.
