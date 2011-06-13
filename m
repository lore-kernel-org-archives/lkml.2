Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1FMKHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:07:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35106 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1FMKHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:07:23 -0400
Date: Mon, 13 Jun 2011 12:07:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 01/15] tracing: Schedule a delayed work to call wakeup()
Message-ID: <20110613100713.GA30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
 <20110609172910.425793191@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609172910.425793191@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> +	const unsigned long delay = msecs_to_jiffies(2); //delay 2 ms

We don't do C++ comments in the kernel ...

Thanks,

	Ingo
