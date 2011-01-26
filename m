Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1AZQeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:34:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53031 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1AZQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:34:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sGkIvdle7SFPr+CLPd9z3jO20FJ/JgW9x0eClx+feNHg4B5awzDywRORFdOIlKCHkC
         tCIK4EgYz/b2aoNWU7bx9Jk+OA1hWnLDmI/Ve4V7rOPtYCQ3wcQzO3rv/8V5F9lIPLhc
         IHPNuLmISxOfgvdtAxdUr8+K1AfdamlARkoSY=
Date: Wed, 26 Jan 2011 17:23:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        stable@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Miller <davem@davemloft.net>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: fix alloc_callchain_buffers()
Message-ID: <20110126162309.GB1757@nowhere>
References: <1295980851.3588.351.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295980851.3588.351.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 07:40:51PM +0100, Eric Dumazet wrote:
> Commit 927c7a9e92c4 ( perf: Fix race in callchains ) introduced a
> mismatch in the sizing of struct callchain_cpus_entries.
> 
> nr_cpu_ids must be used instead of num_possible_cpus(), or we might get
> out of bound memory accesses on some machines.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> CC: David Miller <davem@davemloft.net>
> CC: Stephane Eranian <eranian@google.com>
> CC: stable@kernel.org

Good catch, thanks!
