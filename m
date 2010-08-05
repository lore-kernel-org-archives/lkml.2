Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab0HEMWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:22:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758900Ab0HEMWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:22:11 -0400
Date: Thu, 5 Aug 2010 14:21:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Josh Hunt <johunt@akamai.com>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juhlenko@akamai.com" <juhlenko@akamai.com>
Subject: Re: [PATCH] oprofile: add support for Intel processor model 30
Message-ID: <20100805122158.GA22751@elte.hu>
References: <1280968025-16969-1-git-send-email-johunt@akamai.com>
 <20100805103206.GM26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805103206.GM26154@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3719]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 04.08.10 20:27:05, Josh Hunt wrote:
> > Newer Intel processors identifying themselves as model 30 are not recognized by
> > oprofile.
> 
> > Tested using oprofile 0.9.6.
> > 
> > Signed-off-by: Josh Hunt <johunt@akamai.com>
> 
> Applied to:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> (I converted the model number to hex.)
> 
> Thanks Josh.
> 
> Ingo,
> 
> please (ff-only) pull this again for tip/perf/core. You already send
> the pull request for Linus, but I think this patch will make it for
> v2.6.36 too?

Yeah, we are still early in the merge window, and it's a very small patch in 
any case - i pulled it.

Thanks,

	Ingo
