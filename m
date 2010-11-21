Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0KUOMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:12:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:61901 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0KUOMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:12:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="859905374"
Subject: Re: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore
 events
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
References: <1290340907.2245.125.camel@localhost>
	 <340872239c47b2ec237c88488cb7b6ac.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 22:12:13 +0800
Message-Id: <1290348733.2245.173.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 20:09 +0800, Andi Kleen wrote:
> >
> >              samples  pcnt function               DSO
> >              _______ _____ ______________________
> > ____________________________________
> >
> >                 8.00 18.6% kallsyms_expand_symbol [kernel.kallsyms]
> 
> Reporting a symbol for an uncore event seems highly misleading.
> After all the uncore counter has no idea for which core the event was,
> so there isn't really any instruction pointer to report.
> The event could be event caused by a PCI device or similar.
> 
> For per function monitoring of uncore events one has to use
> OFFCORE_RESPONSE, like I implemented recently.

Let me look at this and then get back to you.

Thanks.

> 
> I would suggest to not report any symbol names for uncore events.
> Doing so just will confuse users.
> 
> In fact I suspect uncore events are only really useful
> with "stat", but not with "top", or if they are used in top
> then the symbol reporting should be disabled.
> 
> -Andi
> 
> 


