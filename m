Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1GMWfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:35:45 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11242 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1GMWfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:35:44 -0400
Date: Thu, 14 Jul 2011 00:35:43 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jiri Kosina <jkosina@suse.cz>,
        =?ISO-8859-15?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo
 'CONFG_FAIR_GROUP_SCHED'
In-Reply-To: <1310595172.2586.48.camel@twins>
Message-ID: <alpine.LNX.2.00.1107140029010.22281@swampdragon.chaosbits.net>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>  <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>  <1310590281.2586.34.camel@twins>  <alpine.LNX.2.00.1107140006170.5754@pobox.suse.cz> <1310595172.2586.48.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Peter Zijlstra wrote:

> On Thu, 2011-07-14 at 00:07 +0200, Jiri Kosina wrote:
> > On Wed, 13 Jul 2011, Peter Zijlstra wrote:
> > 
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
> 
I'd recommend alpine/re-alpine - works well with all mails I receive via 
LKML and elsewhere and I never get complaints about mangled emails from 
people I send patches to (ohh and I happen to like the user interface ;-) 
- check it out.

> > git-am can also apply such thing without any problems with proper accents.
> 
> that's assuming I actually use git at that stage, I find git to be an
> utter pain to gather patches with.

Don't know your workflow, but I can tell you what I do. I just have a 
branch for patches that I'm gathering that are not yet in upstream. Apply 
any new stuff there (or cherry-pick from other branches to my queue 
branch) and then regularly rebase that branch on master (Linus' tree).
When I then want to resend some patches it's as simple as checking out my 
queue branch, doing a rebase to make sure there's no obsolete stuff in it 
and then  git format-patch  to generate mails for the patches I want to 
re-send and then read those patches in to re-alpine and send them.
To me that's not very painfull, but of course it may not match your 
workflow - just a description of mine :-) .

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

