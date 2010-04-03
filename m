Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab0DCNk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 09:40:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51718 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab0DCNkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 09:40:42 -0400
Date: Sat, 3 Apr 2010 10:40:29 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: David Miller <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf symbols: Fill in pgoff in mmap synthesized events
Message-ID: <20100403134029.GC27773@ghostprotocols.net>
References: <20100403115331.GK5594@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403115331.GK5594@kryten>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Apr 03, 2010 at 10:53:31PM +1100, Anton Blanchard escreveu:
> 
> When we synthesize mmap events we need to fill in the pgoff field. 
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Thanks Anton,

	Ingo, I added this one to my perf branch after fixing that
branch due to a problem with the removal of tools/perf/util/string.h.

- Arnaldo
