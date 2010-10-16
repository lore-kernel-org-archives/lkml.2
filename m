Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0JPBIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:08:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0JPBIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:08:49 -0400
X-Authority-Analysis: v=1.1 cv=QISHQ+x4xS+apxgDHgAvNvlUjyrXCzYsHvuXcbPYiKg= c=1 sm=0 a=L0fb2UCT-6QA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=K9Z5GjCpYZ_13tASY3QA:9 a=rooEi_BPrNOAxeUKJQIA:7 a=C8bSYLMAN5Uf54XDYX4iilSKOUMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 8/9] jump label: Make arch_jump_label_text_poke_early()
 optional
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>
In-Reply-To: <4CB8C9D1.1050106@caviumnetworks.com>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201037.703989993@goodmis.org>  <1287176815.1998.117.camel@laptop>
	 <1287176910.16971.2.camel@gandalf.stny.rr.com>
	 <4CB8C61A.2050008@caviumnetworks.com>
	 <1287178546.16971.4.camel@gandalf.stny.rr.com>
	 <4CB8C9D1.1050106@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 21:08:47 -0400
Message-ID: <1287191327.16971.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 14:38 -0700, David Daney wrote:
> On 10/15/2010 02:35 PM, Steven Rostedt wrote:
> > On Fri, 2010-10-15 at 14:22 -0700, David Daney wrote:
> >
> >> Really the SPARC code (and any architectures added in the future with a
> >> well defined optimal NOP) should be doing nothing here as well.
> >>
> >> So I could turn the question around and ask:  How many empty definitions
> >> of this thing do you want in the tree?
> >>
> >> I will defer to Steven.  If he wants to push the empty stubs into all
> >> the architectures, I will update the MIPS patch and he can remove/revert
> >> the 'jump label: Make arch_jump_label_text_poke_early() optional' patch.
> >>
> >> Let me know which option you would prefer.
> >
> > On IRC, Thomas Gleixner mentioned a better solution (something I've done
> > with ftrace). Just add a "weak" stub function. No need to get Kconfig
> > involved.
> >
> 
> Do you want to write that patch, or shall I?

I can do it since I need to clean up some of the patch set anyway.

-- Steve


