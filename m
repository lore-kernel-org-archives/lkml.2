Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1LEMqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:46:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756243Ab1LEMqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:46:38 -0500
Date: Mon, 5 Dec 2011 13:44:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai.lu@oracle.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] x86: use the same node_distance for 32 and 64-bit
Message-ID: <20111205124449.GG3143@elte.hu>
References: <201109191603.15560.hartleys@visionengravers.com>
 <alpine.DEB.2.00.1109191748170.8943@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1110141325010.24783@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110141325010.24783@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Mon, 19 Sep 2011, David Rientjes wrote:
> 
> > On Mon, 19 Sep 2011, H Hartley Sweeten wrote:
> > 
> > > The node_distance function is not x86 64-bit specific.  Having the #ifdef
> > > around the extern function declaration and the #define causes the default
> > > node_distance macro to be used in asm-generic/topology.h. This also causes
> > > a sparse warning in arch/x86/mm/numa.c when CONFIG_X86_64 is not set:
> > > 
> > > warning: symbol '__node_distance' was not declared. Should it be static?
> > > 
> > > Remove the #ifdef to fix both issues.
> > > 
> > > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: Yinghai Lu <yinghai@kernel.org>
> > 
> >  [ I think kernel.org emails are still down, so I sent this to
> >    htejun@gmail.com instead. ]
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > 
> 
> Ingo, Peter, I don't think this was merged into any x86 tree 
> yet (and I gave up trying to figure it out, cloning from 
> tesla.tglx.de was going about 2kB/sec).
> 
> It was also acked by Tejun Heo <tj@kernel.org> during review.

No objections, could someone please resend it with all acks in 
place, and with maintainers Cc:-ed? I don't have the original 
mail in any of my folders.

Thanks,

	Ingo
