Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab0KVUeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:34:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57417 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0KVUeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:34:01 -0500
Date: Mon, 22 Nov 2010 21:33:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH RESEND] tools: add power/x86/x86_energy_perf_policy to
 program MSR_IA32_ENERGY_PERF_BIAS
Message-ID: <20101122203359.GD21836@basil.fritz.box>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
 <alpine.LFD.2.00.1009281143070.14962@localhost.localdomain>
 <alpine.LFD.2.00.1010230035360.29399@localhost.localdomain>
 <alpine.LFD.2.00.1011151103280.2939@x980>
 <8739r0rxlz.fsf@basil.nowhere.org>
 <alpine.LFD.2.00.1011221348200.19247@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011221348200.19247@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 03:13:24PM -0500, Len Brown wrote:
> Per the comments from Andrew and others, the concept of a
> "full tools build" doesn't actually exit (yet).
> 
> So I guess the only assurance that somebody not on x86 would run
> make in this directory this utility lives in tools/power/x86/
> 
> Note that there are other utilities under tools
> which have no Makefile at all...

I suspect this will need to be fixed at some point.

e.g. kernel rpms probably don't want to hard code all of this
but just call some standard make file target. And the kernel
eventually needs a make install_user or similar.

> 
> > ...I would prefer a manpage
> 
> I'll be happy to write a manpage.
> Is there good example I should follow?

Just pick one from /usr/share/man.  You can grep for my 
name if you want one written by me, but I don't claim they are
necessarily better than others @)

> I'm not inclined to bother, as the use-case for this utility
> is to be invoked by another program, and the options available

What other program?

I could well imagine administrators sticking this 
into their boot.locals to set the policy they want.

> In the highly unlikely scenario that somebody uses
> the -r option to excerise the read-only code,
> and simultaneously invokes and completes a cpu hot remove

FWIW there are setups where core offlining can happen
automatically in response to an error.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
