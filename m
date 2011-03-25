Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345Ab1CYK30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:29:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934109Ab1CYK3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:29:25 -0400
Date: Fri, 25 Mar 2011 11:29:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110325102912.GB31903@elte.hu>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324081816.GD30812@elte.hu>
 <20110325032442.GA9313@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110325032442.GA9313@home.goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, Mar 24, 2011 at 09:18:16AM +0100, Ingo Molnar wrote:
> > 
> > * Tejun Heo <tj@kernel.org> wrote:
> > 
> > > NOT-Signed-off-by: Tejun Heo <tj@kernel.org>
> > 
> > s/NOT-// ?
> > 
> 
> Perhaps because it is still in RFC context?

Ok, i guess i was a bit too cryptic about it: the discussion was in support of 
the changes so i asked Tejun above to send a SOB version and did that in a 
geeky way.

And paid my price for the shortcut: had two write two other emails about it 
already ;-)

Thanks,

	Ingo
