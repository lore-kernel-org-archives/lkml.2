Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1GMWZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:25:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1GMWZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:25:24 -0400
Date: Thu, 14 Jul 2011 00:25:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?ISO-8859-15?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo
 'CONFG_FAIR_GROUP_SCHED'
In-Reply-To: <1310595172.2586.48.camel@twins>
Message-ID: <alpine.LNX.2.00.1107140019410.7300@pobox.suse.cz>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>  <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>  <1310590281.2586.34.camel@twins>  <alpine.LNX.2.00.1107140006170.5754@pobox.suse.cz> <1310595172.2586.48.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Peter Zijlstra wrote:

> > > > From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
> > > 
> > > WTF am I to do with crap like that?! 
> > 
> > Peter,
> > 
> > well, umm, get a decent e-mai client? :)
> 
> its my apply scripts that create rubbish, also I'll take recommendations
> for a decent MUA, afaict they're all crap, mutt, claws, thunderbird,
> evolution all suck rocks and its basically picking the one that sucks
> least for your particular workflow.

Well, probably it's just your locale setting that sucks rocks :)

For example pine, mutt and thunderbird (and the later two I almost never 
launch) all show everything correctly for me.

Basically whatever you have in place on your side seems to violate RFC 
2047, which shouldn't cause problems to anybody these days.

Really seems like misconfiguration on your side.

> > git-am can also apply such thing without any problems with proper accents.
> 
> that's assuming I actually use git at that stage, I find git to be an
> utter pain to gather patches with.

Okay, event quilt doesn't chuckle on that patch.

-- 
Jiri Kosina
SUSE Labs
