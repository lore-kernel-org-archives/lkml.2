Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2FKCYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 22:24:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54302 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab2FKCYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 22:24:35 -0400
References: <20120608135200.371649691@goodmis.org> <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com> <1339173716.13377.50.camel@gandalf.stny.rr.com> <4FD23626.4020802@zytor.com> <1339176975.13377.56.camel@gandalf.stny.rr.com> <4FD238CD.8000601@zytor.com> <1339177929.13377.66.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1206110120190.29081@eddie.linux-mips.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.LFD.2.00.1206110120190.29081@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 10 Jun 2012 19:23:59 -0700
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <32f96f44-00a6-4341-a87c-888e0debcebf@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use a VM or a simulator.


"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>On Fri, 8 Jun 2012, Steven Rostedt wrote:
>
>> "Idiot! Why the f*ck are you running i386 on your nice shiny new
>x86_64
>> machine, with Umpteen Gigs of RAM. Boot a x86_64 kernel for Christ
>sake
>> and get your full potential. Your i386 userspace will still work just
>> fine on it. You're like one of those 75 year old retirees that can
>> finally buy a Porsche just to drive it 10 miles per hour below the
>speed
>> limit with a line of cars behind them!"
>
>:)  Yeah, if only native x86_64 could run vm86 so as to ask the VGA
>BIOS 
>to unbotch the graphics card that shot itself into the foot for
>whatever 
>reason, sigh...
>
>  Maciej

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
