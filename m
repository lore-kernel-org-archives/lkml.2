Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209Ab1FWJyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:54:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51636 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab1FWJyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:54:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F1n/4MLkpAZUNmPsP1ofUJczS/T0M+sDVusmP/i3Ua6lw8C75ktPiH2wv0PLjRq1kN
         p8WnID2MZzGvEW0aX/1+SCIFPpk9ugkQERP+LKYvMEmpF3To+aUU5ycnGCB5lN1Q7wXD
         UvM6PsuhUa1QK0fgy0YHs3PZ84LOEiZnZp7pU=
Date: Thu, 23 Jun 2011 13:54:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110623095439.GC10238@sun>
References: <BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
 <20110621172319.GE21641@sun>
 <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
 <20110621175421.GF21641@sun>
 <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
 <20110621183227.GG21641@sun>
 <20110622082756.GK21641@sun>
 <20110622092134.GO21641@sun>
 <20110623064835.GB10238@sun>
 <BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 11:40:39AM +0200, Stephane Eranian wrote:
> On Thu, Jun 23, 2011 at 8:48 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Wed, Jun 22, 2011 at 01:21:34PM +0400, Cyrill Gorcunov wrote:
> > ...
> >> Note that I've not tested it but rather need approval/rejecting
> >> on idea in general.
> >
> > The final version is below. Stephane, note that it's almost the
> > same idea as you proposed except it uses explicit namings to
> > mark out that watchdog cycles are special.
> >
> This looks okay.
> 
> The only alternative I see (This is wha I had in mind at the
> beginning) that would
> not require this new hidden generic event would be to have watchdog.c invoke an
> arch-specific callback to fill out the attr.type, attr->config fields directly:
> 
...
> 
> No new hidden event, just a x86_pmu + a per-arch callbacks.

Looks quite good for me, Don? (i'll cook some draft patch for review meanwhile).

	Cyrill
