Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2H3PJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 11:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2H3PJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 11:09:39 -0400
Date: Thu, 30 Aug 2012 17:11:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH v3] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120830151146.GA26769@redhat.com>
References: <502A0C43.2000906@linutronix.de> <20120814142736.GA8123@redhat.com> <20120820104734.GA17034@linutronix.de> <20120822140337.GB28878@redhat.com> <5034E8A5.2060701@linutronix.de> <20120822155943.GA4237@redhat.com> <20120829173748.GA1121@redhat.com> <20120830084724.GC27415@in.ibm.com> <20120830143724.GA24514@redhat.com> <20120830150335.GA15868@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830150335.GA15868@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30, Ananth N Mavinakayanahalli wrote:
>
> On Thu, Aug 30, 2012 at 04:37:24PM +0200, Oleg Nesterov wrote:
> >
> > So. We can add "weak arch_uprobe" hooks, fix x86, and after powerpc is
> > merged change both powerpc and x86 in one patch (remove "weak" hooks
> > and move enable/disable into arch_pre/post_xol).
> >
> > Or. We can apply the patch I sent right now, you can fix powerpc later,
> > when it is merged. This all is for 3.7 anyway, and fixup is trivial.
> >
> > I agree either way. Which way do you prefer?
>
> I prefer fixing both together later, just so nothing breaks while intial
> testing, etc.

OK.

Oleg.

