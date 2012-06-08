Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410Ab2FHSEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:04:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32839 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab2FHSEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:04:47 -0400
Message-ID: <4FD23EAD.5070605@zytor.com>
Date: Fri, 08 Jun 2012 11:04:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
References: <20120608135200.371649691@goodmis.org>    <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com>   <1339173716.13377.50.camel@gandalf.stny.rr.com>   <4FD23626.4020802@zytor.com>  <1339176975.13377.56.camel@gandalf.stny.rr.com>  <4FD238CD.8000601@zytor.com> <1339177929.13377.66.camel@gandalf.stny.rr.com>
In-Reply-To: <1339177929.13377.66.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 10:52 AM, Steven Rostedt wrote:
> 
> "Idiot! Why the f*ck are you running i386 on your nice shiny new x86_64
> machine, with Umpteen Gigs of RAM. Boot a x86_64 kernel for Christ sake
> and get your full potential. Your i386 userspace will still work just
> fine on it. You're like one of those 75 year old retirees that can
> finally buy a Porsche just to drive it 10 miles per hour below the speed
> limit with a line of cars behind them!"
> 

LOL!

	-hpa

