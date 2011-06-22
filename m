Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1FVJVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:21:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab1FVJVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d/AfJ5M4GH/x4dN3wIx7+klZhStLSExeiQ4ytfnc0GZmrVVsdXmGxvZ8mmETxYqyYV
         faIqD1HwECq5VqQYM1bjW3MsOjT/XCECdt8SwBxRprxIOXxeeQRz3Pbo3nyX8GN5Ronu
         iEv/t/9fW9EUcGylPchBv6gvsnl4smquQeghQ=
Date: Wed, 22 Jun 2011 13:21:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110622092134.GO21641@sun>
References: <BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
 <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
 <20110621164820.GC21641@sun>
 <BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
 <20110621172319.GE21641@sun>
 <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
 <20110621175421.GF21641@sun>
 <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
 <20110621183227.GG21641@sun>
 <20110622082756.GK21641@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622082756.GK21641@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 12:27:56PM +0400, Cyrill Gorcunov wrote:
...
> > 
> > yes, and peterz pointed it out as well, i agree of course.
> > 
> 
> What about something like below?
> 
> 	Cyrill
...
Note that I've not tested it but rather need approval/rejecting
on idea in general.
