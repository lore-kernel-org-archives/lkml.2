Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab1F1PXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:23:11 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46607 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460Ab1F1PVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:21:43 -0400
Date: Mon, 27 Jun 2011 23:32:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
Message-ID: <20110627193201.GB1159@sun>
References: <20110623124918.GC13050@sun>
 <20110627190358.GQ3765@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627190358.GQ3765@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 03:03:58PM -0400, Don Zickus wrote:
...
> 
> > Index: linux-2.6.git/kernel/watchdog.c
> > ===================================================================
> > --- linux-2.6.git.orig/kernel/watchdog.c
> > +++ linux-2.6.git/kernel/watchdog.c
> > @@ -200,6 +200,8 @@ static int is_softlockup(unsigned long t
> >  }
> >  
> >  #ifdef CONFIG_HARDLOCKUP_DETECTOR
> > +void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
> > +
> 
> Though I do wonder about this call in the watchdog.  I thought it might be
> better elsewhere but not sure where.

Yeah, not the _best_ place. Not sure too where to put it, patches are welcome ;)

> 
> Cheers,
> Don

	Cyrill
