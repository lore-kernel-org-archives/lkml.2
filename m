Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab0IOJZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:25:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54015 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0IOJZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:25:49 -0400
Date: Wed, 15 Sep 2010 11:25:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build warnings after merge of the final tree (tip
 treee related)
Message-ID: <20100915092532.GH16593@elte.hu>
References: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>
 <4C8DA517.9000603@kernel.org>
 <20100913143942.7344ada4.sfr@canb.auug.org.au>
 <4C8DDFB4.1020508@kernel.org>
 <20100914145025.977ec2a6.sfr@canb.auug.org.au>
 <4C8FFE76.8070801@kernel.org>
 <20100915150047.42551e34.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915150047.42551e34.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Yinghai,
> 
> On Tue, 14 Sep 2010 16:00:06 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
> >
> > Also, we may need to remove all extern and __init and __initdata etc in .h files.
> > 
> > please check
> > 
> > [PATCH -v3] memblock: Fix section mismatch warning
> > 
> > Use __init_memblock to replace __init, and remove __init in memblock.h
> > 
> > -v2: more with memblock_is_meory()
> > -v3: remove __init for function declaring in memblock.h. Pointed out by Stephen.
> > 
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Yinghai Lu <Yinghai@kernel.org>
> 
> This version fixes all the warnings for me.  So if you put the "extern"s
> back, you can add:
> 
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

Yinghai, mind posting the final version of the patch as a standalone 
posting, with a proper changelog, and with the extern issue fixed as 
well, plus all Reported-by and Tested-by tags added?

Thanks,

	Ingo
