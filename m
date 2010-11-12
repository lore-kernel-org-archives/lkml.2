Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0KLNa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:30:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35073 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab0KLNa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:30:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HE1nUB+wakKHp3rmb7eOjlhqccyOJUy/gZaPSuFnnUxqWLAvShLfzrYM6iryfqcjrK
         2GnIl953YWkRRiF6wQlX8yQ8VwHN7yesggITXM4a01ILrM8+/Dt4JtZThh3yEoCam4s/
         V22I7j8goeP3vvkUFXa3V50tt5M7DCosNBUZE=
Date: Fri, 12 Nov 2010 14:30:22 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@redhat.com, paulus <paulus@samba.org>
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
	events
Message-ID: <20101112133019.GA5595@nowhere>
References: <4CDC3845.4030104@linux.intel.com> <4CDC4628.8020109@linux.vnet.ibm.com> <20101111194936.GJ18718@basil.fritz.box> <1289505587.2084.193.camel@laptop> <20101111201259.GL18718@basil.fritz.box> <1289507858.2084.195.camel@laptop> <20101112102748.GA8020@basil.fritz.box> <AANLkTi=idvNVyccD53Xwjp5mWfJb=S8UXekhXNqhzRPC@mail.gmail.com> <1289561817.2084.240.camel@laptop> <AANLkTinjzZnv8dzfKPzgGtRnk5C-XsAt=gyf_4G0+gf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinjzZnv8dzfKPzgGtRnk5C-XsAt=gyf_4G0+gf8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 02:00:43PM +0100, Stephane Eranian wrote:
> On Fri, Nov 12, 2010 at 12:36 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Fri, 2010-11-12 at 11:49 +0100, Stephane Eranian wrote:
> >> The difficulty with PEBS-LL (load latency) is not so much the encoding of the
> >> latency. It is more how to expose the data back to user. You get a full PEBS
> >> record for each miss. So you get the PEBS machine state + data addr, miss
> >> latency, and data source (where did the line come from). We have already
> >> discussed how to expose machine state in general. I'll work on a patch for this.
> >
> > Frederic was working on this PERF_SAMPLE_REGS stuff as well for his copy
> > the stack top and let dwarfs go wild at it patches.
> >
> Ok, I'll talk to him again about this then.


Would you like me to respin this isolated chunk of my dwarf cfi unwinding patchset?
So that we can discuss the ABI.

Thanks.

