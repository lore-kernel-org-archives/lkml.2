Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1JJGLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:11:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42516 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab1JJGLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:11:13 -0400
Date: Mon, 10 Oct 2011 08:09:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
Message-ID: <20111010060927.GG32173@elte.hu>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
 <1317912555-9559-8-git-send-email-eranian@google.com>
 <20111006153229.GJ14482@one.firstfloor.org>
 <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
 <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com>
 <1317984122.31132.6.camel@twins>
 <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com>
 <1317986519.31132.13.camel@twins>
 <4E8EE885.9040703@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8EE885.9040703@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2011/10/07 20:21), Peter Zijlstra wrote:
> > On Fri, 2011-10-07 at 13:18 +0200, Peter Zijlstra wrote:
> >>> Yeah, depending on the depth of the LBR. But then what happens, you
> >>> decode an instruction that is not what was executed. 
> >>
> >> Right, and Andi's concern is that this might cause our instruction
> >> decoder to blow up, or worse. 
> > 
> > That is, we have a fair confidence that its capable of correctly
> > decoding correct streams, but I understood from Masami that they haven't
> > actually tried feeding it crap.
> 
> OK, I'll do hardening it.

Yes, that's a good idea. Could you perhaps add it to the existing 
build time sanity test we do for the instruction decoder, to feed it 
a sequence of /dev/urandom input or such?

Thanks,

	Ingo
