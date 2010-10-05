Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0JEPfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:35:24 -0400
Received: from www.tglx.de ([62.245.132.106]:58695 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0JEPfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:35:23 -0400
Date: Tue, 5 Oct 2010 17:34:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
cc: robert.richter@amd.com, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 0/3] Basic support for LWP
In-Reply-To: <20101005145155.GD173@escobedo.osrc.amd.com>
Message-ID: <alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com> <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6> <20101005145155.GD173@escobedo.osrc.amd.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, Hans Rosenfeld wrote:

> [ adding Robert ]
> 
> On Mon, Oct 04, 2010 at 06:13:46PM -0400, Thomas Gleixner wrote:
> > > LWP (Light-Weight Profiling) is a new profiling mechanism that allows
> > > user mode processes to gather performance data about themselves with
> > > very low overhead. The specification can be found here:
> > >         http://developer.amd.com/cpu/LWP/Pages/default.aspx
> > 
> > All I can see there is marketing blurb. The spec pdf does not tell me
> > either how the end result of your patches will look like.
> 
> Well, you should get a basic understanding of how LWP works from the
> spec. I'm pretty sure there is more than that blurb in there.
> 
> What I sent _is_ the end result. Supporting LWP in the task switching
> code is the only thing necessary to use the LWP instructions in user
> space. And that is also what I'd like to get some comments on.

So it's the end result. Ok, then explain the following sentence:
 
> > > This code adds basic support for LWP to the context switch code, which
> > > is the minimum needed to use LWP. Support for other LWP features like
> > > interrupts will be added later.

If your patch _IS_ the end result then there are no other LWP
features, right ?

If there are, then your patch is _NOT_ the end result and we really
want to know what is coming.

Thanks,

	tglx
