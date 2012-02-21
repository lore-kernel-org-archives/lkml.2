Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2BUUWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:22:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2BUUWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 15:22:02 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=FUJvpTi5rhPIj8ZZCYMA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329855719.25686.67.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Feb 2012 15:21:59 -0500
In-Reply-To: <4F43F9F0.4000605@zytor.com>
References: <cover.1329851692.git.jbaron@redhat.com>
	 <4F43F9F0.4000605@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 12:09 -0800, H. Peter Anvin wrote:
> On 02/21/2012 12:02 PM, Jason Baron wrote:
> > Hi,
> > 
> > Renames 'static_branch()' -> very_unlikely(), hopefully, to be more intuitive
> > as to what jump labels is about. I'm also introducing 'very_likely()', as
> > the analogue to very_unlikely(). Patch is against the -tip perf branch.
> > 
> 
> Erk... I'm not happy about this.  very_unlikely() makes it sound like it
> operates like unlikely(), which really is not the case.  There is a huge
> difference in mechanism here as well as usage.

I agree with Peter.

What about static_branch_true() and static_branch_false().

Or remove the "_branch" part and have static_true() and static_false()?

-- Steve


