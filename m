Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0IILzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:55:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42884 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0IILzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:55:01 -0400
Date: Thu, 9 Sep 2010 13:54:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 08/43] memblock/microblaze: Use new accessors
Message-ID: <20100909115445.GB16157@elte.hu>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
 <1281071724-28740-9-git-send-email-benh@kernel.crashing.org>
 <4C5BCD41.3040501@monstr.eu>
 <1281135046.2168.40.camel@pasglop>
 <4C88BD8F.5080208@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C88BD8F.5080208@monstr.eu>
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


* Michal Simek <monstr@monstr.eu> wrote:

> Benjamin Herrenschmidt wrote:
> >On Fri, 2010-08-06 at 10:52 +0200, Michal Simek wrote:
> >>Benjamin Herrenschmidt wrote:
> >>>CC: Michal Simek <monstr@monstr.eu>
> >>>Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >>This patch remove bug which I reported but there is another
> >>place which needs to be changed.
> >>
> >>I am not sure if my patch is correct but at least point you on
> >>places which is causing compilation errors.
> >>
> >>I tested your memblock branch with this fix and microblaze can boot.
> >
> >Ok, that's missing in my initial rename patch. I'll fix it up. Thanks.
> >
> >Cheers,
> >Ben.
> 
> I don't know why but this unfixed old patch is in linux-next today.

Yep, i asked benh to have a look (see the mail below) but got no 
response, as i assumed it had all been taken care of.

Ben, Peter?

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Tue, 31 Aug 2010 09:29:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
	tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] memblock: Rename memblock_region to
	memblock_type and memblock_property to memblock_region


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Sat, 2010-08-28 at 00:37 +0000, tip-bot for Benjamin Herrenschmidt
> wrote:
> > Commit-ID:  e3239ff92a17976ac5d26fa0fe40ef3a9daf2523
> > Gitweb:     http://git.kernel.org/tip/e3239ff92a17976ac5d26fa0fe40ef3a9daf2523
> > Author:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > AuthorDate: Wed, 4 Aug 2010 14:06:41 +1000
> > Committer:  Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > CommitDate: Wed, 4 Aug 2010 14:21:49 +1000
> > 
> > memblock: Rename memblock_region to memblock_type and memblock_property to memblock_region
> 
> He, I was just about to rebase them :-)
> 
> Do you still need me to do that ?

Btw., because this is an older base, before we can push this to 
linux-next i suspect we'll need fixes for those architectures that did a 
memblock conversion in this cycle?

Thanks,

	Ingo
	
