Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820Ab2C3NBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760609Ab2C3NBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:01:35 -0400
Date: Fri, 30 Mar 2012 15:01:09 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120330130109.GC1586@m.brq.redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
 <1332938158-5244-4-git-send-email-jolsa@redhat.com>
 <20120330125158.GF1892@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330125158.GF1892@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 04:51:58PM +0400, Cyrill Gorcunov wrote:
> On Wed, Mar 28, 2012 at 02:35:46PM +0200, Jiri Olsa wrote:
> ...
> > +static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
> > +{
> > +	switch (idx) {
> > +	case PERF_X86_64_REG_RAX:
> > +		return regs->ax;
> > +	case PERF_X86_64_REG_RBX:
> > +		return regs->bx;
> > +	case PERF_X86_64_REG_RCX:
> > +		return regs->cx;
> > +	case PERF_X86_64_REG_RDX:
> > +		return regs->dx;
> > +	case PERF_X86_64_REG_RSI:
> > +		return regs->si;
> > +	case PERF_X86_64_REG_RDI:
> > +		return regs->di;
> > +	case PERF_X86_64_REG_R8:
> > +		return regs->r8;
> > +	case PERF_X86_64_REG_R9:
> > +		return regs->r8;
> > +	case PERF_X86_64_REG_R10:
> > +		return regs->r8;
> > +	case PERF_X86_64_REG_R11:
> > +		return regs->r8;
> > +	case PERF_X86_64_REG_R12:
> > +		return regs->r8;
> > +	case PERF_X86_64_REG_R13:
> > +		return regs->r8;
> > +	case PERF_X86_64_REG_R14:
> > +		return regs->r8;
> > +	case PERF_X86_64_REG_R15:
> > +		return regs->r8;
> 
> I guess there are too much r8's :-)
> 
> 	Cyrill

yay :)) right, one should be enough..

thanks,
jirka
