Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0FPUvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:51:23 -0400
Received: from [18.85.46.34] ([18.85.46.34]:40187 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab0FPUvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:51:21 -0400
Date: Wed, 16 Jun 2010 17:50:56 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: avoid synthesizing mmap() for all processes in
 per-thread mode perf record
Message-ID: <20100616205056.GB30679@ghostprotocols.net>
References: <4c192107.4f1ee30a.4316.fffff98e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c192107.4f1ee30a.4316.fffff98e@mx.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 16, 2010 at 08:59:01PM +0200, Stephane Eranian escreveu:
> A bug was introduced by commit c45c6ea2e5c57960dc67e00294c2b78e9540c007.
> 
> Perf record was scanning /proc/PID to create synthetic PERF_RECOR_MMAP
> entries even though it was running in per-thread mode. There was a bogus
> check to select what mmaps to synthesize. We only need all processes in
> system-wide mode.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks, appling to perf/urgent

- Arnaldo
