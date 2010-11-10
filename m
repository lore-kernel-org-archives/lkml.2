Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0KJWWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:22:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37469 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757118Ab0KJWWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:22:11 -0500
Date: Wed, 10 Nov 2010 23:21:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Gamari <bgamari@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>, acme@infradead.org, fweisbec@gmail.com,
        peterz@infradead.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 03/20] x86, mce: Add persistent MCE event
Message-ID: <20101110222157.GA23945@elte.hu>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
 <1288885016-18295-4-git-send-email-bp@amd64.org>
 <87lj50vq0s.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lj50vq0s.fsf@gmail.com>
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


* Ben Gamari <bgamari@gmail.com> wrote:

> On Thu,  4 Nov 2010 16:36:39 +0100, Borislav Petkov <bp@amd64.org> wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Add the necessary glue to enable the mce_record tracepoint on boot
> > turning it into a persistent event. This exports the MCE buffer
> > read-only to a userspace daemon which will hook into it through debugfs
> > when booting is finished.
> 
> While MCE technically is a diagnostics service, do we want to start adding 
> dependencies on debugfs in long-running, common-place daemons? I was under the 
> impression we were to avoid using debugfs for anything other than values for 
> one-off debugging.

See this current discussion thread on lkml:

   [RFC][PATCH] perf: sysfs type id

Events are being added to sysfs as we want to avoid the debugfs dependency.

Thanks,

	Ingo
