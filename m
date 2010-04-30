Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab0D3R6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:58:25 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:45038 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563Ab0D3RyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:54:14 -0400
X-Greylist: delayed 2786 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 13:54:13 EDT
Date: Fri, 30 Apr 2010 11:28:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
Message-ID: <20100430092835.GI11032@elte.hu>
References: <4BD80037.9060704@kernel.org>
 <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz>
 <20100430075510.GA21105@elte.hu>
 <alpine.LNX.2.00.1004300957130.9849@pobox.suse.cz>
 <20100430083720.GA3318@elte.hu>
 <alpine.LNX.2.00.1004301103280.9849@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004301103280.9849@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0263]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 30 Apr 2010, Ingo Molnar wrote:
> 
> > > Well, Paul himself stated that according to their lawyer department, 
> > > "Copyright" (which is there) is enough. So it made sense to remove invalid 
> > > (at least in some sense) character.
> > > 
> > > Also zillion of other files copyrighted by Paul contain "Copyright (C)".
> > > 
> > > If we really want this character there then, why not rather in UTF-8, so 
> > > that it works flawlessly?
> > 
> > It might be fine but i havent seen Paul reply to this thread - and this is my 
> > point: _you_ should have waited for an ack from Paul (who is co-maintaining 
> > that file) before applying it. The commit doesnt have it:
> 
> I got Pauls reply as "as soon as there is `Copyright', it's fine". [...]

If lkml was not Cc:-ed to that reply (which appears to be the case) then it's 
worth asking for / waiting for an explicit ack.

> [...] If I misunderstood it, sorry for that, and I'll drop the patch.
> 
> Paul, could you please send explicit Acked-by: or Naked-by:, so that 
> everything is in line?

And in that case my NAK is moot.

Thanks,

	Ingo
