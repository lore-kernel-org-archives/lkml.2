Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0LCNFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:05:47 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47089 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab0LCNFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:05:46 -0500
Date: Fri, 3 Dec 2010 11:05:28 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/4] perf/core improvements
Message-ID: <20101203130528.GB19363@ghostprotocols.net>
References: <1291318772-30880-1-git-send-email-acme@infradead.org>
 <1291356549-sup-6865@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291356549-sup-6865@au1.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 03, 2010 at 05:10:44PM +1100, Ian Munsie escreveu:
> Excerpts from Arnaldo Carvalho de Melo's message of Fri Dec 03 06:39:28 +1100 2010:
> >     Ian, if you prefer, please test it before Ingo merges it.
> 
> Have done so and just about finished rebasing my patches on top of these
> - I'll try to get them posted tonight. The bug I was working on is
> fixed, so I'm happy :)

Great!
 
> I haven't come across the bug that Thomas ran into, but then again I
> haven't been testing the non-perf parts of perf for this either.

I'll work on the problem related by Thomas today.
 
> Which reminds me, does anyone have a test suite for perf other than
> ./perf test?

Not that I know of, perf test is intended to be that, please consider
adding more tests :)

I want to do things like start a thread that will generate cache misses,
and then have a monitor thread measuring it, passing the test if it gets
into some range (its sampling after all), etc.

- Arnaldo
