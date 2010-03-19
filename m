Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0CSHld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 03:41:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0CSHlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 03:41:31 -0400
Date: Fri, 19 Mar 2010 08:41:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, fweisbec@gmail.com,
       sparclinux@vger.kernel.org, tj@kernel.org
Subject: Re: [PATCH v2][GIT PULL][v2.6.34] ring-buffer: Do 8 byte alignment
 for 64 bit that can not handle 4 byte align
Message-ID: <20100319074109.GB12576@elte.hu>
References: <1268966657.758.28.camel@gandalf.stny.rr.com>
 <20100318.200347.115945905.davem@davemloft.net>
 <1268968559.758.31.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268968559.758.31.camel@gandalf.stny.rr.com>
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

> Rebased to add David's ACK.
> 
> Ingo,
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Steven Rostedt (1):
>       ring-buffer: Do 8 byte alignment for 64 bit that can not handle 4 byte align

Pulled, thanks a lot Steve!

	Ingo
