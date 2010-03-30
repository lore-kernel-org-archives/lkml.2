Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0C3PLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:11:41 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:48412 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0C3PLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ShJ//BWo/RAtxcrbmC0baLHj3GcxgM55jsQECBW3SOMP0reGM+NvbYESbameGK/kwb
         GH75LlHZWyayTA1ysNzX7l0jIrUWZwZDT30OFifCRPQNn9i36S7PwzFluMq9sjhz+o0p
         bpFLCDvdIXt7HD07LmAxJ8b7PW8/bpSHg7N0E=
Date: Tue, 30 Mar 2010 19:11:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
Message-ID: <20100330151133.GB5211@lenovo>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com> <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com> <20100330134145.GI11907@erda.amd.com> <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com> <1269961255.5258.221.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269961255.5258.221.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 05:00:55PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 15:53 +0200, Stephane Eranian wrote:
> > > So, there are some ARCH_PERFMON_EVENTSEL_* masks that are Intel only,
> > > which is true for ARCH_PERFMON_EVENTSEL_ANY. And indead, the code
> > > should be checked for this. ARCH_PERFMON_EVENTSEL_ANY is always
> > > cleared on AMD cpus, so this code is ok. Actually the bit is cleared
> > 
> > Until AMD uses that bit too and you won't notice this test. This is a security
> > check specific to Intel and it should be in an Intel-specific function.
> > 
> > > for *all* cpus in x86_pmu_raw_event(), the code was and is broken for
> > > this.
> > >
> > Yes, needs to be authorized for any perfmon v3 and later revisions.
> 
> So how about something like this on top of Robert's patches?
> 
[...]

Looks good for me! Thanks Peter!

	-- Cyrill
