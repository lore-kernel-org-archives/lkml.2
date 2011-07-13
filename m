Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1GMWsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:48:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1GMWsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:48:22 -0400
Date: Thu, 14 Jul 2011 00:48:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?ISO-8859-15?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo
 'CONFG_FAIR_GROUP_SCHED'
In-Reply-To: <1310596663.2586.55.camel@twins>
Message-ID: <alpine.LNX.2.00.1107140041090.7300@pobox.suse.cz>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>  <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>  <1310590281.2586.34.camel@twins>  <alpine.LNX.2.00.1107140006170.5754@pobox.suse.cz>  <1310595172.2586.48.camel@twins> 
 <alpine.LNX.2.00.1107140019410.7300@pobox.suse.cz> <1310596663.2586.55.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Peter Zijlstra wrote:

> > For example pine, mutt and thunderbird (and the later two I almost never 
> > launch) all show everything correctly for me.
> > 
> > Basically whatever you have in place on your side seems to violate RFC 
> > 2047, which shouldn't cause problems to anybody these days.
> > 
> > Really seems like misconfiguration on your side.
> 
> They show the utf8 string without problems, but calling any one of them
> a decent MUA is far beyond where I can go, they're barely usable piles
> of crap.

Umm, so? :)

> > > > git-am can also apply such thing without any problems with proper accents.
> > > 
> > > that's assuming I actually use git at that stage, I find git to be an
> > > utter pain to gather patches with.
> > 
> > Okay, event quilt doesn't chuckle on that patch.
> 
> I'm sure, quilt doesn't care about what's before the --- line, and in
> fact they applied just fine. 
> 
> But my cobbled together script doesn't do horrid utf8 demunging and thus
> had this terrible mess as a From: field. 
> 
> Also isn't the kernel source in LANG=C (aka ASCII?).

The sources are one thing (and even that doesn't hold ... for example a 
lot of places hold copyright sign that is not '(C)' but this UTF-8 thing). 
But the authorship/changelog information is a different story, right?

Just for code authors with non-ascii names:

$ git log | git shortlog -n | grep '^[^ ]' | grep -P "[\x80-\xFF]" | wc -l
245

(now admittedly some of those are results of broken scripts/systems such 
as yours, but most of them are valid).


Now, I have to finally add, I don't care a bit. At all. I just have been 
CCed -- for some odd reason -- on the original patch, and wanted to defend 
Jan against your 'wtf shitty crap you are sending' offenses, as he did 
absolutely nothing wrong (if at least RFCs and 99% of Internet can be 
taken as an etalon), and crap is IMHO located elsewhere :)

Thanks,

-- 
Jiri Kosina
SUSE Labs
