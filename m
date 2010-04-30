Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab0D3RHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:07:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab0D3RH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:07:26 -0400
Date: Fri, 30 Apr 2010 11:04:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
In-Reply-To: <20100430083720.GA3318@elte.hu>
Message-ID: <alpine.LNX.2.00.1004301103280.9849@pobox.suse.cz>
References: <4BD80037.9060704@kernel.org> <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz> <20100430075510.GA21105@elte.hu> <alpine.LNX.2.00.1004300957130.9849@pobox.suse.cz> <20100430083720.GA3318@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, Ingo Molnar wrote:

> > Well, Paul himself stated that according to their lawyer department, 
> > "Copyright" (which is there) is enough. So it made sense to remove invalid 
> > (at least in some sense) character.
> > 
> > Also zillion of other files copyrighted by Paul contain "Copyright (C)".
> > 
> > If we really want this character there then, why not rather in UTF-8, so 
> > that it works flawlessly?
> 
> It might be fine but i havent seen Paul reply to this thread - and this is my 
> point: _you_ should have waited for an ack from Paul (who is co-maintaining 
> that file) before applying it. The commit doesnt have it:

I got Pauls reply as "as soon as there is `Copyright', it's fine". If I 
misunderstood it, sorry for that, and I'll drop the patch.

Paul, could you please send explicit Acked-by: or Naked-by:, so that 
everything is in line?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
