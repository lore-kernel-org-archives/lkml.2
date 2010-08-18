Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab0HRDvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 23:51:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41521 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0HRDvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 23:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G9muWyfmPnYXuw8lQvrbrjXYXvN59gNh4asZaObDt7fM2WMFE4CQNbuB6Iqf13alWO
         ++hvNQpJEx5rCvpYmaDWYOrlEPrxS19jSyymNigy/FvITNfkq8HObrgFgEax3jcotFpm
         11JrHogaIayto7tkCywE6rYD7BH4e3lOFscwI=
Date: Wed, 18 Aug 2010 05:51:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
        Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 3/6] perf: Generalize some arch callchain code
Message-ID: <20100818035109.GC24748@nowhere>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com> <1281991715-10367-4-git-send-regression-fweisbec@gmail.com> <20100817034634.GB24726@drongo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817034634.GB24726@drongo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 01:46:34PM +1000, Paul Mackerras wrote:
> On Mon, Aug 16, 2010 at 10:48:32PM +0200, Frederic Weisbecker wrote:
> 
> > - Most archs use one callchain buffer per cpu, except x86 that needs
> >   to deal with NMIs. Provide a default perf_callchain_buffer()
> >   implementation that x86 overrides.
> > 
> > - Centralize all the kernel/user regs handling and invoke new arch
> >   handlers from there: perf_callchain_user() / perf_callchain_kernel()
> >   That avoid all the user_mode(), current->mm checks and so...
> > 
> > - Invert some parameters in perf_callchain_*() helpers: entry to the
> >   left, regs to the right, following the traditional (src, dst).
> 
> I think you mean (dst, src), don't you?


Indeed yeah :)



 
> Apart from that, the patch looks OK, so
> 
> Acked-by: Paul Mackerras <paulus@samba.org>


Thanks a lot for your reviews and acks!

