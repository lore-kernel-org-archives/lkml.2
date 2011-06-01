Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1FAHGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:06:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43842 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab1FAHGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:06:24 -0400
Date: Wed, 1 Jun 2011 09:06:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: Split up buffer handling from core code
Message-ID: <20110601070616.GA32308@elte.hu>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
 <1305827704-5607-1-git-send-email-fweisbec@gmail.com>
 <20110531182252.GA5256@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531182252.GA5256@somewhere.redhat.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, May 19, 2011 at 07:55:04PM +0200, Frederic Weisbecker wrote:
> > And create the internal perf events header.
> > 
> > v2: Keep an internal inlined perf_output_copy()
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Stephane Eranian <eranian@google.com>
> > ---
> 
> Are you guys fine with his patch?
> If so, should I queue it myself and send a pull request?

Yeah, please do it ASAP.

> I prefer to work step by step on this split, to avoid too much 
> review burden. And also a single detail can require to rework the 
> whole.

Please lets just start it so that the interactions get smaller! 

core.c couldnt be uglier as it is today, so after a first raw split 
we can sort out any fine details - just make sure you don't break the 
build.

Thanks,

	Ingo
