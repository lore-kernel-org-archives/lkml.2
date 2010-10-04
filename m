Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0JDSCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:02:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:51942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab0JDSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:02:52 -0400
Date: Mon, 4 Oct 2010 15:02:00 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com
Subject: Re: [PATCH] perf: fix extern struct definitions
Message-ID: <20101004180200.GC4420@ghostprotocols.net>
References: <4c97e41a.078fd80a.7a8b.3cc9@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c97e41a.078fd80a.7a8b.3cc9@mx.google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 21, 2010 at 12:45:01AM +0200, Stephane Eranian escreveu:
> Both python_scripting_ops and perl_scripting_ops have two global definitions.
> One in trace-event-scripting.c and one in their respective scripting-engine
> modules.
> 
> The issue is that depending on the linker order one definition or the other
> is chosen. One is uninitialized (bss), while the other is initialized. If
> the uninitialized version is chosen, then perf does not function properly.
> 
> This patch fixes this by adding the extern prefix to the definitions in
> trace-event-scripting.c. 
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks, applying to perf/urgent,

- Arnaldo
