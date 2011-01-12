Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1ALRHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:07:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:59338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab1ALRHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:07:30 -0500
Date: Wed, 12 Jan 2011 15:07:17 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Q: perf log mode?
Message-ID: <20110112170716.GB24598@ghostprotocols.net>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
 <20110112152112.GE11968@ghostprotocols.net>
 <20110112163131.GA2924@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112163131.GA2924@tugrik.mns.mnsspb.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 12, 2011 at 07:31:32PM +0300, Kirill Smelkov escreveu:
> As I wrote in my first mail, maybe a bit not explicitly (sorry then), the
> latency is introduced in perf-record. I'm telling this because I've

Ok, all is well and we'll tune the kernel to do it as we need using your
patch.

> visually monitored perf-record output to console (yes, binary output,
> but it does not matter) to see whether there is output progress at all.
> 
> After initial startup there was no progress for long time and then bunch
> of data after 30-40 seconds.
> 
> 
> And with the patch posted inline within reply-to-Peter mail, the delay
> goes away, so could you please consider applying it?

I will.
