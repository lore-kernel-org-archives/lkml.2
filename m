Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0IMUmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:42:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60656 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab0IMUma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:42:30 -0400
Date: Mon, 13 Sep 2010 22:42:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/1] perf/core ui browser improvement
Message-ID: <20100913204217.GA2505@elte.hu>
References: <1284395692-11298-1-git-send-email-acme@infradead.org>
 <20100913174845.GC18428@elte.hu>
 <20100913190758.GB31907@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913190758.GB31907@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1966]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Mon, Sep 13, 2010 at 07:48:45PM +0200, Ingo Molnar escreveu:
> > Nice, it's more economic with screen real estate now :-)
> > 
> > btw., a small detail: could we please rename [kernel.kallsyms] to 
> > [kernel]? The user is not really interested where the symbols came from 
> > (kallsyms or vmlinux), in 99.9% of the cases - and the many repetitive 
> > .kallsyms instances look uninformative and somewhat confusing.
> 
> Sure, I'll probably even remove the brackets :-)

The brackets kind of make sense, they signal that it's a container 
(which it is) - same for DSOs.

Thanks,

	Ingo
