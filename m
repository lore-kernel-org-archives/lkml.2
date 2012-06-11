Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2FKAZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:25:51 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:60622 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2FKAZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:25:50 -0400
Date: Mon, 11 Jun 2012 01:25:47 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
In-Reply-To: <1339177929.13377.66.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1206110120190.29081@eddie.linux-mips.org>
References: <20120608135200.371649691@goodmis.org>           <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com>          <1339173716.13377.50.camel@gandalf.stny.rr.com>          <4FD23626.4020802@zytor.com>         <1339176975.13377.56.camel@gandalf.stny.rr.com>
         <4FD238CD.8000601@zytor.com> <1339177929.13377.66.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012, Steven Rostedt wrote:

> "Idiot! Why the f*ck are you running i386 on your nice shiny new x86_64
> machine, with Umpteen Gigs of RAM. Boot a x86_64 kernel for Christ sake
> and get your full potential. Your i386 userspace will still work just
> fine on it. You're like one of those 75 year old retirees that can
> finally buy a Porsche just to drive it 10 miles per hour below the speed
> limit with a line of cars behind them!"

 :)  Yeah, if only native x86_64 could run vm86 so as to ask the VGA BIOS 
to unbotch the graphics card that shot itself into the foot for whatever 
reason, sigh...

  Maciej
