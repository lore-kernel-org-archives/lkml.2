Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2BFTZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:25:20 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11468 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2BFTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:25:18 -0500
Date: Mon, 6 Feb 2012 20:25:47 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Steven Rostedt <rostedt@goodmis.org>
cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [tip:perf/urgent] trace events: Update version number reference
 to new 3.x scheme for EVENT_POWER_TRACING_DEPRECATED
In-Reply-To: <1328549630.2200.19.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LNX.2.00.1202062024530.20117@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net>  <tip-f629299b544b6cc12b4e3e85fec96f4ce5809482@git.kernel.org> <1328549630.2200.19.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012, Steven Rostedt wrote:

> On Mon, 2011-07-25 at 20:06 +0000, tip-bot for Jesper Juhl wrote:
> > Commit-ID:  f629299b544b6cc12b4e3e85fec96f4ce5809482
> > Gitweb:     http://git.kernel.org/tip/f629299b544b6cc12b4e3e85fec96f4ce5809482
> > Author:     Jesper Juhl <jj@chaosbits.net>
> > AuthorDate: Sun, 24 Jul 2011 23:15:42 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 25 Jul 2011 09:37:21 +0200
> > 
> > trace events: Update version number reference to new 3.x scheme for EVENT_POWER_TRACING_DEPRECATED
> > 
> > What was scheduled to be 2.6.41 is now going to be 3.1 .
> 
> I see the comment here also states that this code would be removed in
> 3.1, where as we are now heading towards 3.3 and Arjan said it doesn't
> hurt to keep the code.
> 
> I guess this comment needs to be removed too?
> 

I already submitted a patch to do just that : 
http://lkml.indiana.edu/hypermail/linux/kernel/1202.0/02085.html

And I can see in -next that Jiri already too that one in his tree.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

