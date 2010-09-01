Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0IAN7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:59:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab0IAN7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:59:48 -0400
X-Authority-Analysis: v=1.1 cv=F68j8apdn+AYvba2s2WjKYIAmW276Pjvg9wPu/ZwFig= c=1 sm=0 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Dhx35ztt3x_e9n0ohKEA:9 a=ReiOnyhL_wKtAhkcwWnGE-_v7Y8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: ftrace/perf_event leak
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20100901121518.GA5378@nowhere>
References: <4C7E11E5.1040402@redhat.com> <1283331868.2059.808.camel@laptop>
	 <4C7E1C36.6070400@redhat.com> <4C7E1F12.8030304@cn.fujitsu.com>
	 <4C7E2D1D.3080603@redhat.com> <1283338977.2059.938.camel@laptop>
	 <20100901121518.GA5378@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 01 Sep 2010 09:59:45 -0400
Message-ID: <1283349585.2356.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 14:15 +0200, Frederic Weisbecker wrote:

> Thanks for fixing this.
> 
> However, can we split this in two patches to ease the backport?
> 
> The lack of a module_put() after perf_trace_init() failure is there for a while
> (the backport needs to start in 2.6.32).
> 
> But the lack of a module_put in the destroy path needs a .35 backport only.

I don't think it really needs two patches. Just notify stable (and 
Greg KH in particular) about the backport requirements. Greg can handle
it ;)

-- Steve


