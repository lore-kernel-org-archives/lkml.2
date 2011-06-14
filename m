Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1FNIE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:04:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab1FNIEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:04:53 -0400
Date: Tue, 14 Jun 2011 10:04:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, tj@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
Message-ID: <20110614080436.GB29900@elte.hu>
References: <20110601172543.437240675@linux.com>
 <20110601172614.173427964@linux.com>
 <4DF09827.7070809@cs.helsinki.fi>
 <alpine.DEB.2.00.1106101016420.30968@router.home>
 <BANLkTikHOsvR-KXZ-VQvpAaMgrNOR0sB3g@mail.gmail.com>
 <alpine.DEB.2.00.1106111202110.32170@router.home>
 <4DF6F659.3000109@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF6F659.3000109@cs.helsinki.fi>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On 6/11/11 8:02 PM, Christoph Lameter wrote:
> >On Sat, 11 Jun 2011, Pekka Enberg wrote:
> >
> >>Oh, I don't know - but I definitely need more ACKs to even consider
> >>pushing this through slab.git.
> >
> >Any additional ackers out there?;-)
> 
> Ingo, ping? Could we have this in -tip so I can pull from there? 
> This is blocking me from queuing SLUB performance improvements to 
> linux-next.

hpa, what's your take on this patch?

Thanks,

	Ingo
