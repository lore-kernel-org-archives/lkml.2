Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab0KGMic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:38:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47563 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0KGMib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:38:31 -0500
Date: Sun, 7 Nov 2010 13:37:46 +0100
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
Message-ID: <20101107123746.GA5413@elte.hu>
References: <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
 <20101107085016.GA23843@elte.hu>
 <20101107094932.GT4627@1wt.eu>
 <20101107114237.GA3759@elte.hu>
 <20101107115145.GW4627@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107115145.GW4627@1wt.eu>
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

> > All must be closed down for unprivileged user-space, for this to be effective, 
> > obviously.
> 
> This would only be effective against finding a precise version. [...]

I'm glad that you agree with my point.

> [...] There's no need for that, what you want is to hide kernel pointers, [...]

That's a new claim from you - and when put like that it's wrong too: if the goal is 
to introduce risk of detection to attackers (which i suggested to be an efficient 
security measure), then hiding/fuzzing version information is an essential/needed 
piece of such a measure, not something for which there is 'no need'.

Hiding the address of kernel data/code structures is another piece of such a larger 
goal. Btw., as i argued it to Marcus already, hiding /proc/kallsyms will not hide 
these addresses on the vast majority of Linux systems, and that the patch would only 
cure the symptom, not the cause:

 |
 | But without actually declaring and achieving that sandboxing goal this security 
 | measure is just a feel-good thing really [...]
 |

Anyway, i wasnt particularly successful in conveying my past arguments to you so i'd 
rather leave the discussion at this point. You made your points and i made my points 
as well.

Thanks,

	Ingo
