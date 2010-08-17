Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0HQExk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:53:40 -0400
Received: from ozlabs.org ([203.10.76.45]:57990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab0HQExh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:53:37 -0400
Date: Tue, 17 Aug 2010 14:37:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
        Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 2/6] perf: Generalize callchain_store()
Message-ID: <20100817043722.GC24726@drongo>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
 <1281991715-10367-3-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281991715-10367-3-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 10:48:31PM +0200, Frederic Weisbecker wrote:

> callchain_store() is the same on every archs, inline it in
> perf_event.h and rename it to perf_callchain_store() to avoid
> any collision.
> 
> This removes repetitive code.

Acked-by: Paul Mackerras <paulus@samba.org>
