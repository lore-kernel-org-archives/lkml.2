Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab0FROiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:38:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33216 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933476Ab0FROiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:38:08 -0400
Date: Fri, 18 Jun 2010 16:37:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100618143749.GA14034@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
 <1276862130.1875.7.camel@laptop>
 <20100618122532.GB9045@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618122532.GB9045@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > So aside from the should this be perf or not, the above is utter
> > gibberish. Whoever came up with this nonsense?
> 
> This is pretty much how softirqs (and before them bottom halves) work.
> I believe Linus invented that scheme originally back in the early
> days of Linux.

Nope - the softirq code was written by Alexey Kuznetsov and David S. Miller. 
But it's irrelevant, because:

> It's actually quite simple and works well

... as Peter said the last thing we want is yet another softirq vector.

Thanks,

	Ingo
