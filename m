Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1JLHHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:07:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1JLHHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:07:47 -0400
Date: Wed, 12 Oct 2011 09:06:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
Message-ID: <20111012070601.GC18618@elte.hu>
References: <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
 <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com>
 <1317984122.31132.6.camel@twins>
 <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com>
 <1317986519.31132.13.camel@twins>
 <4E8EE885.9040703@hitachi.com>
 <20111010060927.GG32173@elte.hu>
 <4E92FBAD.3000108@hitachi.com>
 <20111010144538.GZ14482@one.firstfloor.org>
 <4E943DB4.1070400@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E943DB4.1070400@hitachi.com>
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


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2011/10/10 23:45), Andi Kleen wrote:
> >> Ah, nice. Maybe we need another test binary, since current one is
> >> just ensuring the output of objdump and decoder is same.
> >> anyway it's not so difficult if it feeds random binaries to
> >> ensure the decoder doesn't access bad address.
> > 
> > Pure /dev/urandom is not good because it cannot be ever reproduced.
> > Better use a PRNG with random seed from urandom, but print the seed.
> 
> Sure,

Obviously the urandom data should be kbuild generated and only 
cleared on 'make clean' - not regenerated on every run. So if there's 
a failure the failing urandom data stays around readily.

Thanks,

	Ingo
