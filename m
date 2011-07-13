Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1GMWoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:44:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53734 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1GMWoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:44:17 -0400
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo 'CONFG_FAIR_GROUP_SCHED'
From: Peter Zijlstra <peterz@infradead.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Jiri Kosina <jkosina@suse.cz>,
        "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1107140029010.22281@swampdragon.chaosbits.net>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310590281.2586.34.camel@twins>
	 <alpine.LNX.2.00.1107140006170.5754@pobox.suse.cz>
	 <1310595172.2586.48.camel@twins>
	 <alpine.LNX.2.00.1107140029010.22281@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Jul 2011 00:44:03 +0200
Message-ID: <1310597043.2586.60.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 00:35 +0200, Jesper Juhl wrote:
> 
> Don't know your workflow, but I can tell you what I do. I just have a 
> branch for patches that I'm gathering that are not yet in upstream. Apply 
> any new stuff there (or cherry-pick from other branches to my queue 
> branch) and then regularly rebase that branch on master (Linus' tree).
> When I then want to resend some patches it's as simple as checking out my 
> queue branch, doing a rebase to make sure there's no obsolete stuff in it 
> and then  git format-patch  to generate mails for the patches I want to 
> re-send and then read those patches in to re-alpine and send them.
> To me that's not very painfull, but of course it may not match your 
> workflow - just a description of mine :-) . 

Right, so I find cherry-picking and rebasing using git the most painful
thing ever.

Also, using quilt you get a plain text version of the patch you can edit
at your leisure, editing a git patch involves some export, import and
rebase foo which is all too much work.

Furthermore, using quilt I get help from useful tools like rej and meld
git-merge otoh creates these god-awful merge markers that no tool can
deal with.

As for re-alpine, I might actually try it, you're the second one
promoting it. Although I had somewhat hoped for a MUA like sup to become
useful (or notmuch to grow a usable front-end). Traditional MUAs simply
can't seem to cope well with today's number of emails.
