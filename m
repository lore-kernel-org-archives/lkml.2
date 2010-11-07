Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0KGI47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 03:56:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49352 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab0KGI46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 03:56:58 -0500
Date: Sun, 7 Nov 2010 09:56:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101107085641.GB23843@elte.hu>
References: <20101104100914.GC25118@suse.de>
 <20101104114648.GA23381@elte.hu>
 <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104223526.GC31236@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> > Not an 'arms race' thing where we just put obstruction in the road of attackers 
> > - but some real, unavoidable risk not detectable by attackers - running on most 
> > stock distro kernels. (so there would be a real economy of scale)
> > 
> > The kerneloops client could also collect exploit attempt stats.
> 
> Well, in my opinion, either the attacker is remote and you can already get many 
> info, or he's local and has time to precisely qualify the environment in order not 
> to leave the slightest trace. [...]

Your view of how attackers operate is rather simplistic. Knowing the precise 
environment (via remote or local measures) is a big tactical advantage to them.

See the very patch we are discussing. People are submitting patches to hide certain 
pieces of information exactly because that information is an advantage to attackers.

And my point is that "if you want to hide information do it effectively - or if it's 
too hard dont do it at all".

Thanks,

	Ingo
