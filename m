Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab1CHQPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:15:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40732 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab1CHQPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:15:47 -0500
Date: Tue, 8 Mar 2011 17:15:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        masami.hiramatsu.pt@hitachi.com, hpa@zytor.com, ananth@in.ibm.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        eric.dumazet@gmail.com, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/2] x86: separating entry text section
Message-ID: <20110308161524.GE1751@elte.hu>
References: <20110220125948.GC25700@elte.hu>
 <1298298313-5980-1-git-send-email-jolsa@redhat.com>
 <1298298313-5980-2-git-send-email-jolsa@redhat.com>
 <20110222080934.GB7001@elte.hu>
 <20110222125201.GB1884@jolsa.brq.redhat.com>
 <20110307104423.GA3661@jolsa.redhat.com>
 <20110307152921.GC28226@elte.hu>
 <20110307181039.GB15197@jolsa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307181039.GB15197@jolsa.redhat.com>
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


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Mar 07, 2011 at 04:29:21PM +0100, Ingo Molnar wrote:
> > 
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > hi,
> > > any feedback?
> > 
> > Did you get my reply below?
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> 
> hi,
> 
> strange, I believe I did reply on this.. got missed
> somehow or I'm missing simething :) reattached..

hm, the direct mail to me got lost, but i found your reply in the lkml folder. 
That's how i missed your reply.

> I made another test with "reseting" the system state as suggested and only for 
> cache-misses together with instructions and cycles events.
> 
> I can see even bigger drop of icache load misses than before
> from 19359739 to 16448709 (about 15%).
> 
> The instruction/cycles count is slightly bigger in the patched
> kernel run though..

Ok, elapsed time is more stable, it went from:

>         0.205402048  seconds time elapsed   ( +-   0.299% )
>         0.206267711  seconds time elapsed   ( +-   0.138% )

to:

>         0.206072845  seconds time elapsed   ( +-   0.276% )
>         0.206747566  seconds time elapsed   ( +-   0.137% )

which is 0.1% slower, within the noise of the measurement.

Will apply the patches, thanks Jiri!

Thanks,

	Ingo
