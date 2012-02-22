Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2BVQIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:08:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20846 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab2BVQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:08:03 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Eg4S8c21MHScLgdx5AsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329926881.25686.111.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 11:08:01 -0500
In-Reply-To: <20120222155602.GC3405@redhat.com>
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
	 <20120222155602.GC3405@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 10:56 -0500, Jason Baron wrote:
> On Wed, Feb 22, 2012 at 10:54:03AM -0500, Steven Rostedt wrote:
> > On Wed, 2012-02-22 at 10:42 -0500, Jason Baron wrote:
> > 
> > > Do you have 'CONFIG_CC_OPTIMIZE_FOR_SIZE' set?
> > 
> > Yes I do :-p
> > 
> > But that's because the distro config I started with had it set too.
> > 
> > -- Steve
> > 
> > 
> 
> Right, with CONFIG_CC_OPTIMIZE_FOR_SIZE unset, which is the default, at
> least on x86, I have not seen a single case of the 'jmp;jmp'.
> 

What the config default is, is unimportant. It only maters to kernel
hackers that build our own kernels. What's important is what distros do.

On debian testing I have in config-3.0.0-1-amd64:

CONFIG_CC_OPTIMIZE_FOR_SIZE=y


Although it is not set on the latest fedora 16 config.

Someone should tell debian to turn it off.

-- Steve


