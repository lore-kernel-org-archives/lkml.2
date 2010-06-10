Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab0FJMKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:10:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54379 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976Ab0FJMKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:10:05 -0400
Date: Thu, 10 Jun 2010 14:09:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/23] x86: percpu: Avoid warnings of unused variables
 in per cpu
Message-ID: <20100610120951.GC16514@elte.hu>
References: <20100610110.764742110@firstfloor.org>
 <20100610111036.DAE8EB1A2C@basil.firstfloor.org>
 <4C10C930.9080900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C10C930.9080900@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> On 06/10/2010 01:10 PM, Andi Kleen wrote:
> > Avoid hundreds of warnings with a gcc 4.6 -Wall build
> > 
> > Cc: tj@kernel.org
> > Cc: x86@kernel.org
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Can x86 or -mm please take this patch?  There isn't any pending percpu
> patch currently and it seems a bit silly to start a branch for this
> one.

Sure, queued it up.

Thanks,

	Ingo
