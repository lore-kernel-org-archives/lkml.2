Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1D3ILm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 04:11:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40234 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1D3ILh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 04:11:37 -0400
Date: Sat, 30 Apr 2011 10:11:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110430081132.GA3705@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Vince Weaver <vweaver1@eecs.utk.edu>, Ingo Molnar <mingo@elte.hu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Robert Richter <robert.richter@amd.com>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <20110429164227.GA25491@elte.hu>
 <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu>
 <20110429185741.GB10217@elte.hu>
 <alpine.DEB.2.00.1104292200110.9459@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104292200110.9459@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:17:04PM -0400, Vince Weaver wrote:
> > AMD managed to keep a large chunk of their events stable even across very 
> > radical changes of the underlying hardware. I have two AMD systems produced 
> > *10* years apart and they even use the same event encodings for the major 
> > events.
> 
> Well guess what, AMD family 15h changes all of that.

I don't see a big problem here, Robert has a patch that takes care of
counter constraints. It probably needs a bit more work but we'll get
where we need to be.

> And you're not going to like LWP. They got tired of waiting for a
> workable kernel perf counter interface and moved it completely to
> usersapce,

I don't know where you get your information but that's absolutely and
completely not nearly even beginning to smell the truth.

> and there's nothing you can do about it unless you start blocking the
> xsave patches from getting in.

Look at tip/x86/xsave, looks like LWP support will most likely be in
2.6.40.

-- 
Regards/Gruss,
    Boris.
