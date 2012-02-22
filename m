Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2BVP4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:56:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2BVP4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:56:21 -0500
Date: Wed, 22 Feb 2012 10:56:03 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222155602.GC3405@redhat.com>
References: <20120222074839.GA24890@elte.hu>
 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
 <20120222080659.GA25318@elte.hu>
 <1329916920.25686.79.camel@gandalf.stny.rr.com>
 <20120222133404.GA14085@elte.hu>
 <1329918881.25686.92.camel@gandalf.stny.rr.com>
 <20120222145614.GA2491@elte.hu>
 <1329923533.25686.106.camel@gandalf.stny.rr.com>
 <20120222154206.GA3405@redhat.com>
 <1329926043.25686.107.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329926043.25686.107.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 10:54:03AM -0500, Steven Rostedt wrote:
> On Wed, 2012-02-22 at 10:42 -0500, Jason Baron wrote:
> 
> > Do you have 'CONFIG_CC_OPTIMIZE_FOR_SIZE' set?
> 
> Yes I do :-p
> 
> But that's because the distro config I started with had it set too.
> 
> -- Steve
> 
> 

Right, with CONFIG_CC_OPTIMIZE_FOR_SIZE unset, which is the default, at
least on x86, I have not seen a single case of the 'jmp;jmp'.

Thanks,

-Jason
