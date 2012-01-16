Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2APHZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:25:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46649 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2APHZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:25:16 -0500
Date: Mon, 16 Jan 2012 08:24:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ben Hutchings <ben@decadent.org.uk>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH][GIT PULL][v3.3] tracepoints/module: Fix disabling
 tracepoints with taint CRAP or OOT
Message-ID: <20120116072456.GA15641@elte.hu>
References: <1326658250.7642.136.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326658250.7642.136.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

>  	/*
>  	 * We skip modules that tain the kernel, especially those with different

While touching this commit we might as well fix the typo here?

>  	 * module header (for forced load), to make sure we don't cause a crash.

... and the second typo as well?

> +	 * Staging and out-of-tree modules are fine.
>  	 */

I'd phrase it as 'out-of-tree GPL modules'.

Thanks,

	Ingo
