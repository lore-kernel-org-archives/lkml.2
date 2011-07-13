Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1GMXnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:43:42 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12028 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1GMXnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:43:41 -0400
Date: Thu, 14 Jul 2011 01:43:40 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jiri Kosina <jkosina@suse.cz>,
        =?ISO-8859-15?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo
 'CONFG_FAIR_GROUP_SCHED'
In-Reply-To: <1310599104.2586.68.camel@twins>
Message-ID: <alpine.LNX.2.00.1107140139070.22281@swampdragon.chaosbits.net>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>  <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>  <1310590281.2586.34.camel@twins>  <alpine.LNX.2.00.1107140006170.5754@pobox.suse.cz>  <1310595172.2586.48.camel@twins> 
 <alpine.LNX.2.00.1107140029010.22281@swampdragon.chaosbits.net>  <1310597043.2586.60.camel@twins>  <alpine.LNX.2.00.1107140057240.22281@swampdragon.chaosbits.net> <1310599104.2586.68.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Peter Zijlstra wrote:

> On Thu, 2011-07-14 at 01:03 +0200, Jesper Juhl wrote:
> > Do yourself a favour, if you try it, and spend a bit of time in the Setup 
> > menu configuring it to the threading style you want, the headers you want 
> > displayed by default, etc etc... The defaults are less than perfect if you 
> > ask me, but it's quite configurable :) 
> 
> It seems to suffer the same problem mutt does, trying to sort a folder
> with a shade under 600000 emails in it doesn't work (500+ seconds in
> waiting and still nothing).
> 
> Evolution seems to pull it off in a few seconds, I very frequently flip
> between threaded and received time sort, evo's problem is in it
> consuming a silly amount of memory to do it (current res footprint of
> evo is 1.3g).
> 
> I thought this was a solved problem by the VLDB people way back in the
> 60s or 70s when 0.6M was still large.
> 

Sure, some of the sort modes are slow - but only really slow on initial 
load. On refreshes it's much faster. So for someone like me, who just runs 
alpine in a screen on his server, that pain is minimal (only when I need 
to reboot the server do I have to pay the loooooong sort delay).

But, some sort modes are quick, and you can select them when starting 
alpine, like :   $ pine -sort arrival/reverse
That's about as quick as you can get if you just want to start it with a 
uge inbox anbd just have a quick look. But, if you just sort your inbox 
into smaller folders that takes a lot of the pain away. Personally I try 
to keep my inbox (and all other folders) below 20000 emails and then even 
the initial, first run, sorting delay is acceptable (to me).

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

