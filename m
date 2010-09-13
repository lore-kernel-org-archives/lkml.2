Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0IMTIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:08:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab0IMTIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:08:12 -0400
Date: Mon, 13 Sep 2010 16:07:58 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/1] perf/core ui browser improvement
Message-ID: <20100913190758.GB31907@ghostprotocols.net>
References: <1284395692-11298-1-git-send-email-acme@infradead.org>
 <20100913174845.GC18428@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913174845.GC18428@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 13, 2010 at 07:48:45PM +0200, Ingo Molnar escreveu:
> Nice, it's more economic with screen real estate now :-)
> 
> btw., a small detail: could we please rename [kernel.kallsyms] to 
> [kernel]? The user is not really interested where the symbols came from 
> (kallsyms or vmlinux), in 99.9% of the cases - and the many repetitive 
> .kallsyms instances look uninformative and somewhat confusing.

Sure, I'll probably even remove the brackets :-)

- Arnaldo
