Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab1CXS7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:59:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933584Ab1CXS7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:59:24 -0400
Date: Thu, 24 Mar 2011 19:59:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
Message-ID: <20110324185903.GA30510@elte.hu>
References: <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
 <20110324172653.GA28507@elte.hu>
 <alpine.DEB.2.00.1103241242450.32226@router.home>
 <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
 <alpine.DEB.2.00.1103241300420.32226@router.home>
 <AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
 <alpine.DEB.2.00.1103241312280.32226@router.home>
 <1300990853.3747.189.camel@edumazet-laptop>
 <alpine.DEB.2.00.1103241346060.32226@router.home>
 <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_00,URIBL_RHS_DOB autolearn=no SpamAssassin version=3.3.1
	1.5 URIBL_RHS_DOB          Contains an URI of a new domain (Day Old Bread)
	[URIs: linux.com]
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Mar 24, 2011 at 8:47 PM, Christoph Lameter <cl@linux.com> wrote:
> >
> > On Thu, 24 Mar 2011, Eric Dumazet wrote:
> >
> >> > this_cpu_cmpxchg16b_emu:
> >> >         pushf
> >> >         cli
> >> >
> >> >         cmpq %gs:(%rsi), %rax
> >
> >> Random guess
> >>
> >> Masking interrupts, and accessing vmalloc() based memory for the first
> >> time ?
> >
> > Hmmm.. Could be. KVM would not really disable interrupts so this may
> > explain that the test case works here.
> >
> > Simple fix would be to do a load before the cli I guess.
> 
> Btw, I tried Ingo's .config and it doesn't boot here so it's somehow
> .config related.

did you get a similar early crash as i? I'd not expect my .config to have all 
the drivers that are needed on your box.

Thanks,

	Ingo
