Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab2AFKHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:07:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab2AFKHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:07:32 -0500
Date: Fri, 6 Jan 2012 11:05:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
Message-ID: <20120106100520.GA7962@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
 <20120105091704.GB3249@elte.hu>
 <CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
 <20120106073635.GC14188@elte.hu>
 <20120106012120.32c3f370.akpm@linux-foundation.org>
 <20120106094339.GA9990@elte.hu>
 <20120106015808.1655d1c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106015808.1655d1c9.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Maybe true for a general purpose computer, but someone who is 
> making a single-purpose device such as a digital TV or a wifi 
> router won't want it.

That's the case for 99% of the features and semantics we have: 
by definition a single-purpose device uses only a small sub-set 
of an infinite purpose OS, right?

Still we only modularize semantics out if they easily fit into 
some existing plug-in/module concept, if the feature is arguably 
oddball that a sizable portion of people want to disable, or if 
it makes notable sense for size reasons. To me it looked 
distinctly silly to complicate things for such a small piece of 
code.

I doubt Kees would mind modularizing it, but it would be nice to 
get VFS maintainer feedback in the:

   { 'you are crazy, over my dead body' ... 'cool, merge it' }

continuous spectrum of possible answers.

Thanks,

	Ingo
