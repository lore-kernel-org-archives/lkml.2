Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2ILSsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab2ILSsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:48:45 -0400
Date: Wed, 12 Sep 2012 15:48:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Namhyung Kim <namhyung@kernel.org>, mingo@kernel.org, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf hists: Introduce perf_hpp for hist period
 printing
Message-ID: <20120912184815.GC557@infradead.org>
References: <1346640790-17197-2-git-send-email-namhyung@kernel.org>
 <tip-ea251d51d2c7d7233790123227f787c477f567f5@git.kernel.org>
 <20120912172641.GB29278@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912172641.GB29278@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 12, 2012 at 07:26:41PM +0200, Robert Richter escreveu:
> On 09.09.12 01:54:39, tip-bot for Namhyung Kim wrote:
> 
>  # perf record -e cycles -aq sleep 1 ; perf report -n --sort comm,dso | sed '/%/q;d' ; \
>    perf record -e cycles -aq sleep 1 | perf report -n --sort comm,dso | sed '/%/q;d'
>      99.86%        11804       swapper  [kernel.kallsyms]
>      91.57%      swapper  [kernel.kallsyms]
>            ^^^^^^
>            number of samples missing
> 
> Moving and changing the code at the same time make the patch
> unreviewable. So no clue that's the problem here.

Yeah, that was unfortunate (movind and changing), we need to try hard
not to do that...

Anyway, Namhyung, can you take a look at this?

- Arnaldo
