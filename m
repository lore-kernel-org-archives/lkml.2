Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2FFPhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:37:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58319 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2FFPhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:37:21 -0400
Date: Wed, 6 Jun 2012 17:37:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Darren Hart <dvhart@linux.intel.com>, Hitoshi Mitake <h.mitake@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Michel Lespinasse <walken@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] perf bench: add new benchmark subsystem and suite "futex
 wait"
Message-ID: <20120606153715.GA7842@gmail.com>
References: <1337268092-6765-1-git-send-email-h.mitake@gmail.com>
 <4FB52636.3040604@linux.intel.com>
 <CAMO-S2g9fkg_KH0CPOsB_7GQTN2mu8zir+UZDp6=VC+7XDrfrg@mail.gmail.com>
 <CAMO-S2gyzK3VTQcTRw+FAO9ui_gy=1z=MVxUYM9sPN51KrDgkg@mail.gmail.com>
 <4FCE4D24.5040307@linux.intel.com>
 <20120606073909.GI17808@gmail.com>
 <20120606123023.GB2423@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606123023.GB2423@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Wed, Jun 06, 2012 at 09:39:09AM +0200, Ingo Molnar escreveu:
> > I'd rather not split it from the main perf binary, if embedded 
> > wants a small static binary (do they really?) we could add 
> > support for minimal builds of perf, with just a few [even one] 
> > subcommand activated or so.
> 
> The plan is to be able to do a:
> 
> make -C tools/perf menuconfig
> 
> And all the other *config make targets as the kernel, using Kconfig
> files, etc.
> 
> So that we can pick and choose which subset of tools and features one
> wants.

Sounds very nifty to me!

Thanks,

	Ingo
