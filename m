Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313Ab2FHSJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:09:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58943 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2FHSJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:09:47 -0400
Date: Fri, 8 Jun 2012 20:09:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
Message-ID: <20120608180943.GA18312@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20120608135200.371649691@goodmis.org>
 <20120608135603.699156773@goodmis.org>
 <4FD223E1.1090707@zytor.com>
 <1339173716.13377.50.camel@gandalf.stny.rr.com>
 <4FD23626.4020802@zytor.com>
 <1339176975.13377.56.camel@gandalf.stny.rr.com>
 <4FD238CD.8000601@zytor.com>
 <1339177929.13377.66.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339177929.13377.66.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 01:52:09PM -0400, Steven Rostedt wrote:
> "Idiot! Why the f*ck are you running i386 on your nice shiny new x86_64
> machine, with Umpteen Gigs of RAM. Boot a x86_64 kernel for Christ sake
> and get your full potential. Your i386 userspace will still work just
> fine on it. You're like one of those 75 year old retirees that can
> finally buy a Porsche just to drive it 10 miles per hour below the speed
> limit with a line of cars behind them!"

If you make this into a patch, you can have my vehement ACK.

-- 
Regards/Gruss,
    Boris.
