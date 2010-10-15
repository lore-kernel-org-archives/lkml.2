Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0JODX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:23:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0JODXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:23:25 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=9WCZY-WHpdEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=Ca8mbl0af9GwDsIm0GsA:9 a=Ru4SxFZIe-8lOUF6SUqX8sHXLtIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/3] ftrace/x86: Add support for C version of
 recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-arch@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        John Reiser <jreiser@bitwagon.com>
In-Reply-To: <20101015031832.GG9640@elte.hu>
References: <20101014210014.895157788@goodmis.org>
	 <20101014210136.230687571@goodmis.org> <20101015025047.GA9640@elte.hu>
	 <1287112449.23682.27.camel@gandalf.stny.rr.com>
	 <20101015031832.GG9640@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Oct 2010 23:23:23 -0400
Message-ID: <1287113003.23682.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 05:18 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 2010-10-15 at 04:50 +0200, Ingo Molnar wrote:
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:

> > Also, perl was much easier to do.
> 
> Lets write the whole kernel in perl and forget about performance ;-)

Shhh, you're letting people know about my evil secret agenda!


> > > 
> > > The naming is inconsistent here - it should be HAVE_C_RECORDMCOUNT, like 
> > > the build variable has, and like the utility is called. If we are going 
> > > to add this flag to most architectures we should name it consistently.
> > 
> > Sure, want me to rebase it or just write a patch on top of it?
> 
> Sure, patch on top would be fine.

OK, I'll add a patch on top.

Thanks,

-- Steve


