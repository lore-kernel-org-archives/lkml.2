Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab0JVCwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:52:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:47768 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0JVCwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:52:51 -0400
Date: Fri, 22 Oct 2010 00:52:45 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: why could cause PerfTop get nothing output ?
Message-ID: <20101022025245.GJ23835@ghostprotocols.net>
References: <AANLkTi=vJArRbLup=F2duoxx47LFGTT3++4QiFZHJbzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vJArRbLup=F2duoxx47LFGTT3++4QiFZHJbzQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Oct 09, 2010 at 05:07:42AM -0400, Luming Yu escreveu:
> Hi acme,
> 
> I got nothing output as below, wondering if it was due to too few interrupts ?

Try using a higher frequency:

perf top -F 100000

> Is it possbile to get perf top based on samples from other Perf events?

Yes, any event, just specify it like:

perf top -e instructions

- Arnaldo

> [root@localhost clocksource0]# rpm -qa | grep perf
> perf-2.6.36-0.35.rc7.git0.fc15.x86_64
> [root@localhost clocksource0]# uname -a
> Linux localhost.localdomain 2.6.36-0.35.rc7.git0.fc15.x86_64 #1 SMP
> Wed Oct 6 22:02:54 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux
> [root@localhost clocksource0]# perf top
> 
> -------------------------------------------------------------------------------
>    PerfTop:       0 irqs/sec  kernel:-nan%  exact: -nan% [1000Hz
> cycles],  (all, 2 CPUs)
> -------------------------------------------------------------------------------
> 
>              samples  pcnt  DSO
>              _______ _____
