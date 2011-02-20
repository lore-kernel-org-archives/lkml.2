Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1BTRLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:11:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41514 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab1BTRLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:11:42 -0500
Date: Sun, 20 Feb 2011 18:11:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Add extra gcc checks
Message-ID: <20110220171122.GA7050@elte.hu>
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298219710-9846-1-git-send-email-bp@alien8.de>
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


* Borislav Petkov <bp@alien8.de> wrote:

> Add a 'W=1' Makefile switch which adds additional checking per build
> object.
> 
> The idea behind this option is targeted at developers who, in the
> process of writing their code, want to do the occasional
> 
> make W=1 [target.o]
> 
> and let gcc do more extensive code checking for them. Then, they
> could eyeball the output for valid gcc warnings about various
> bugs/discrepancies which are not reported during the normal build
> process.
> 
> For more background information and a use case, read through this
> thread: http://marc.info/?i=20110218091716.GA4384@bicker
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Borislav Petkov <bp@alien8.de>

Nice.

Acked-by: Ingo Molnar <mingo@elte.hu>

We enable a lot of GCC warnings in tools/perf/ as well, and while there are false 
positives occasionally, the general effect on code quality is positive. We combine 
it with -Werror to make sure warnings do not accumulate.

Thanks,

	Ingo
