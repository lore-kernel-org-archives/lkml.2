Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2CERUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:20:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154Ab2CERUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:20:41 -0500
Date: Mon, 5 Mar 2012 18:20:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, ravitillo@lbl.gov,
        khandual@linux.vnet.ibm.com, asharma@fb.com, robert.richter@amd.com,
        ming.m.lin@intel.com, vweaver1@eecs.utk.edu, andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120305172008.GA29411@elte.hu>
References: <20120224094048.GA7952@quad>
 <20120305154753.GA14604@elte.hu>
 <20120305155011.GA32413@elte.hu>
 <20120305155642.GB32413@elte.hu>
 <1330965033.11248.240.camel@twins>
 <CABPqkBQ5iC9TB=W4=19SghYdz9D6z6sXrBerm78TuVwk+W8sBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ5iC9TB=W4=19SghYdz9D6z6sXrBerm78TuVwk+W8sBQ@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> On Mon, Mar 5, 2012 at 5:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2012-03-05 at 16:56 +0100, Ingo Molnar wrote:
> >> A third usability bug is that for some reason a branch sampling
> >> 'perf report' defaults to the stdio output on my testsystem -
> >> with --no-branch-stack it gives the regular tui.
> >>
> >>
> > Ah, I would not have noticed that since I still explicitly 
> > build my perf without TUI support. That stuff mostly just 
> > gets in the way.
> 
> I tend to agree with Peter here.

I use the TUI most of the time (it allows me to navigate and 
look at annotated output easily - something the --stdio one 
cannot do), and I know at least two other kernel developers who 
prefer the TUI, so it's a YMMV thing.

> There is no TUI support for branch as of now.

Why? What would be needed to add proper TUI support?

Thanks,

	Ingo
