Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab0HQKeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:34:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35348 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab0HQKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:34:16 -0400
Subject: Re: [RFC PATCH 0/0 v3] callchain fixes and cleanups
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Borislav Petkov <bp@amd64.org>
In-Reply-To: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:32:39 +0100
Message-ID: <1282041159.22114.2.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2010 10:32:44.0172 (UTC) FILETIME=[8705ECC0:01CB3DF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 21:48 +0100, Frederic Weisbecker wrote:
> Hi,
> 
Hi Frederic,
> 
> This set factorizes a lot of callchain code and fixes concurrent
> callchain buffers accesses.

> You can test it by pulling that branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
>         perf/callchains
> 

I've tested this on an ARM Cortex-A9 board and it all seems fine [plus
the code is a lot cleaner!].

Tested-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will

