Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab1F1Pld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:41:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758761Ab1F1Phl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:37:41 -0400
Date: Tue, 28 Jun 2011 11:37:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
Message-ID: <20110628153731.GY3765@redhat.com>
References: <20110623124918.GC13050@sun>
 <20110627190358.GQ3765@redhat.com>
 <20110627193201.GB1159@sun>
 <CABPqkBTE_6ma70ZQbbz1NnznCGB7YO74kmL+=fP66qFVvVFLBw@mail.gmail.com>
 <20110628152827.GE1159@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628152827.GE1159@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 07:28:27PM +0400, Cyrill Gorcunov wrote:
> On Tue, Jun 28, 2011 at 05:24:36PM +0200, Stephane Eranian wrote:
> ...
> > >
> > > Yeah, not the _best_ place. Not sure too where to put it, patches are welcome ;)
> > >
> > No matter what, this file has to remain in a file that's common to all arch.
> 
> well, hard to say, Stephane, nmi-watchdog is x86 specific as far as I know.

No, other arches have similar mechanisms.  Actually I think sparc
copied-n-pasted an old implementation of the nmi_watchdog on x86.

It is just all we hear about is the watchdog on x86.

Cheers,
Don
