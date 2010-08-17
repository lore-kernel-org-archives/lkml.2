Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0HQEx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:53:58 -0400
Received: from ozlabs.org ([203.10.76.45]:57999 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab0HQExi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:53:38 -0400
Date: Tue, 17 Aug 2010 14:37:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
        Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 4/6] perf: Factorize callchain context handling
Message-ID: <20100817043754.GD24726@drongo>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
 <1281991715-10367-5-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281991715-10367-5-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 10:48:33PM +0200, Frederic Weisbecker wrote:

> Store the kernel and user contexts from the generic layer instead
> of archs, this gathers some repetitive code.

Acked-by: Paul Mackerras <paulus@samba.org>
