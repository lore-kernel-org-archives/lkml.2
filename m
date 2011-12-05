Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1LEJtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:49:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab1LEJtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:49:18 -0500
Date: Mon, 5 Dec 2011 10:47:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/10] [GIT PULL] tracing: various fixes
Message-ID: <20111205094718.GA9614@elte.hu>
References: <20111108012939.372220547@goodmis.org>
 <20111111083339.GD14347@elte.hu>
 <1322602385.17003.89.camel@frodo>
 <20111203092043.GA2739@elte.hu>
 <1323045081.19933.79.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323045081.19933.79.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 2011-12-03 at 10:20 +0100, Ingo Molnar wrote:
> 
> > Hm, not all were regression fixes and the branch was named 
> > */core so i took it into perf/core.
> 
> Yeah it happened just at the end of the merge window. I didn't really
> know what branch to name it.
> 
> > 
> > Could you perhaps cherry-pick the most crutial regression 
> > fixes into an urgent branch? We could still push that 
> > upstream.
> 
> Looking at each patch, I would say 6 of the ten need to go in. 
> Most are marked as stable since they break the last tree. I 
> could just send them all to stable if it seems strange to have 
> this many patches in two pull requests.

We can cherry-pick those 6 patches into perf/urgent - just make 
sure you merge the cherry-picked branch into your devel branch 
before adding new changes to the same files, there will be tons 
of conflicts otherwise.

Thanks,

	Ingo
