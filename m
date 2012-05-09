Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068Ab2EIJZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:25:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50128 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab2EIJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:25:42 -0400
Date: Wed, 9 May 2012 11:25:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next oops in __lock_acquire for process_one_work
Message-ID: <20120509092536.GC8585@gmail.com>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
 <20120507175743.GC19417@google.com>
 <1336482202.16236.29.camel@twins>
 <20120508165819.GB10687@google.com>
 <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
 <1336516260.8226.61.camel@twins>
 <alpine.LSU.2.00.1205081553250.4497@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205081553250.4497@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hughd@google.com> wrote:

> On Wed, 9 May 2012, Peter Zijlstra wrote:
> > On Tue, 2012-05-08 at 11:11 -0700, Hugh Dickins wrote:
> > > Please send me the version of patch you'd like to put in
> > > (lest I make it up myself and you don't like the result).
> > 
> > something like so?
> 
> More like the one below: I'm not alone in preferring a comma 
> between args!

Silly compilers!

> And you're not a believer in checkpatch.pl, I see: I've removed trailing
> spaces; but left the 85-col line, that's not a fight I'll have with you.

I suspect we could break up the prototype like this:

static inline void
lockdep_copy_map(struct lockdep_map *to, struct lockdep_map *from)

> I'll set it going when I get home later - thanks.

Do we still need an explanation about why it's needed and why it 
makes a difference?

Thanks,

	Ingo
