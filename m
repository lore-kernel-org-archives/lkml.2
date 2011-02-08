Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1BHPO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:14:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50086 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1BHPOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:14:55 -0500
Date: Tue, 8 Feb 2011 16:14:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Friesen <chris.friesen@genband.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /proc/<pid>/sched should contain cumulative data for all
 threads in process
Message-ID: <20110208151434.GA20357@elte.hu>
References: <4D50723B.7020400@genband.com>
 <1297156865.13327.57.camel@laptop>
 <20110208121144.GA7550@elte.hu>
 <1297172742.13327.102.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297172742.13327.102.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Very much depends on what is wanted, but most of the stuff inside those files is 
> very specific to the implementation and pinning any of that to an ABI is like 
> silly.

Why? If the implementation changes then those values lose meaning and the most 
correct value to report is *zero* and that's it.

That's how such things were always done, it was never a problem in the past 15 
years. Why should it start being a problem suddenly?

Thanks,

	Ingo
