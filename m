Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2BXPwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:52:01 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42573 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754567Ab2BXPv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:51:58 -0500
Date: Fri, 24 Feb 2012 10:51:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, a.p.zijlstra@chello.nl,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
	+ docs
Message-ID: <20120224155155.GA19381@Krystal>
References: <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com> <20120222081855.GB25318@elte.hu> <20120222213343.GA19758@bloggs.ozlabs.ibm.com> <20120223100205.GD24310@elte.hu> <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com> <20120223223348.GA25513@elte.hu> <20120223223933.GA7942@elte.hu> <20120223231842.GA31030@Krystal> <20120224022512.GA3777@redhat.com> <20120224090811.GB814@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224090811.GB814@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:50:25 up 457 days, 20:53,  5 users,  load average: 0.16, 0.10,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
[...]
> > [...] so we are going to have to change either the branch site 
> > or the test for true/false name. The above 
> > 'static_key_inline_true/false' solves that.
> 
> It's generally good practice to make the mostly commonly used 
> method names the simplest/shortest names - i.e. I don't think we 
> should make it longer via adding an _inline to every use.
> 
> In that sense static_key_true() has pretty optimal length - we'd 
> like these tests to also be visually unintrusive.
> 
> So in the latest patch (still under testing, will push it out 
> soon) we have:
> 
> 	static_key_true()
> 	static_key_false()
> 	static_key_enabled()

Hi Ingo,

Yes, I think your proposal makes sense. The "_inline_" would add lots of
typing for little clarity value. And I guess people will get used to
these constructs.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
