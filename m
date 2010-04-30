Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0D3QsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:48:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab0D3QrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:24 -0400
Date: Fri, 30 Apr 2010 10:01:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
In-Reply-To: <20100430075510.GA21105@elte.hu>
Message-ID: <alpine.LNX.2.00.1004300957130.9849@pobox.suse.cz>
References: <4BD80037.9060704@kernel.org> <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz> <20100430075510.GA21105@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, Ingo Molnar wrote:

> > > The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
> > > causes annoying problems with some editors and tools.  Use (C)
> > > instead.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Paul Mackerras <paulus@au1.ibm.com>
> > > ---
> > > I'm not really sure this would survive transport over mail in
> > > appliable form, attaching the patch too just in case.
> > 
> > It didn't survive :) But it was easy enough to fix by hand. Applied, 
> > thanks Tejun.
> 
> NAK.
> 
> A similar patch was sent a few weeks ago, it was objected to and rejected - 
> the copyright character was used for legal reasons.

Well, Paul himself stated that according to their lawyer department, 
"Copyright" (which is there) is enough. So it made sense to remove invalid 
(at least in some sense) character.

Also zillion of other files copyrighted by Paul contain "Copyright (C)".

If we really want this character there then, why not rather in UTF-8, so 
that it works flawlessly?

> Jiri, in the future please dont apply 'trivial' patches that involve 
> subsystems that i co-maintain and which is not acked by any of the subsystem 
> maintainers.

OK, as you wish.

-- 
Jiri Kosina
