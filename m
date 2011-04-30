Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188Ab1D3BuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 21:50:08 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:36673 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761118Ab1D3BuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 21:50:07 -0400
Date: Fri, 29 Apr 2011 21:49:29 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Borislav Petkov <bp@alien8.de>
cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <20110429221642.GA10751@liondog.tnic>
Message-ID: <alpine.DEB.2.00.1104292146120.9459@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <20110429164227.GA25491@elte.hu> <20110429221642.GA10751@liondog.tnic>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Borislav Petkov wrote:

> On Fri, Apr 29, 2011 at 06:42:27PM +0200, Ingo Molnar wrote:
> >  "Thinking is hard, lets go shopping^W exporting raw ABIs."

> We're always bitching about Linux usability and now when it comes down
> to yet another case where this can be done right for a change, and perf
> people are trying to do something productive, you come waving hands
> loudly at Linus with revert requests instead of helping. This is as
> productive as trying to shoot yourself in the foot.

Have I proposed that the "perf" tool be changed at all?

No.  Never.

I proposed that the interface to allow raw access to offcore events _not_ 
be disabled so that advanced tools can access it directly.

I don't care how perf works.  Nor do I care how many pointless generic 
events get added to the kernel (other than being annoyed about it taking 
up extra bytes in my kernel image).

Reverting this patch would have absolutely no bearing on "perf", the 
usability of perf, or anything that any normal user sees.  I'm not sure 
how the argument is even getting framed that way.

Vince
