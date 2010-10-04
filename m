Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0JDWPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:15:03 -0400
Received: from www.tglx.de ([62.245.132.106]:41299 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab0JDWPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:15:01 -0400
Date: Tue, 5 Oct 2010 00:13:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 0/3] Basic support for LWP
In-Reply-To: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
Message-ID: <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Hans Rosenfeld wrote:

> LWP (Light-Weight Profiling) is a new profiling mechanism that allows
> user mode processes to gather performance data about themselves with
> very low overhead. The specification can be found here:
>         http://developer.amd.com/cpu/LWP/Pages/default.aspx

All I can see there is marketing blurb. The spec pdf does not tell me
either how the end result of your patches will look like.

> This code adds basic support for LWP to the context switch code, which
> is the minimum needed to use LWP. Support for other LWP features like
> interrupts will be added later.

Oh no. We are not going to merge that and give you a card blanche to
come up with another profiling/performance monitoring facility which
is completely disconnected to everything else.

Please provide either the full patch of this facility or at least a
reasonable explanation how it will look like when your code is
ready. What's the user space interface, how does it hook into perf,
etc ...

Thanks,

	tglx
