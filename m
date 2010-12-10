Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0LJPLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:11:43 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:55660 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0LJPLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:11:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d7RRfNeCSzZg/3HV68Z8205cvSXPSnDLTVUKvt6Y4Kpvn3ODUpfWzMaWIKeW3Nai4v
         G/OTNGHIBuXuvoVCeB9yrDQ5Sef4HbF57S56p9H4PLbcEXjmgB5Z6PBHouAZ/6SKms3c
         qBrBviJJRlIdqCh6NVjXYVj5iQknmM2U3EZTA=
Date: Fri, 10 Dec 2010 18:11:35 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
Message-ID: <20101210151135.GA7695@lenovo>
References: <1291267223.2405.314.camel@minggr.sh.intel.com> <1291922467.6803.44.camel@twins> <AANLkTinanAQYQvwtowTzJ0bpLRUvp-5sqF6M9PoMSJR-@mail.gmail.com> <1291978036.6803.95.camel@twins> <1291978335.6803.97.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291978335.6803.97.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 11:52:15AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-12-10 at 11:47 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-12-10 at 00:46 +0100, Stephane Eranian wrote:
> > > Hi,
> > > 
> > > So I have tested this patch a bit on WSM and as I expected there
> > > are issues with sampling.
> > > 
> > > When HT is on, both siblings CPUs get the interrupt. The HW does not
> > > allow you to only point interrupts to a single HT thread (CPU).
> > 
> > Egads, how ugly :/
> >

crap...
...
 
> 
> That would of course need to also grow some smarts to detect if there is
> only 1 sibling online.
> 
> CC'ed Cyrill as P4 might have something similar.
> 

Yes, Don was testing p4 stuff for me and have reported this issue as well.
I'll check what I can do. Thanks for CC'ing me.

  Cyrill
