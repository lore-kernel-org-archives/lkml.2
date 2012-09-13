Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2IMPWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:22:06 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:17153
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287Ab2IMPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:22:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAAO0K-02-I91-02
X-M-MSG: 
Date: Thu, 13 Sep 2012 17:21:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf record: Change error message on failure
Message-ID: <20120913152145.GG8285@erda.amd.com>
References: <1347531654-16024-1-git-send-email-robert.richter@amd.com>
 <20120913150720.GA27411@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120913150720.GA27411@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.09.12 17:07:20, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > Only report
> > 
> >  No CONFIG_PERF_EVENTS=y kernel support configured?
> > 
> > if the syscall fails with ENOSYS. In other cases CONFIG_PERF_EVENTS is
> > set and might confuse users. The default message is now:
> > 
> >  Not all events could be opened.
> 
> Indeed, and it would be nice to be even less passive-aggressive 
> and figure out and display the exact error condition?

The complete error message shows the error condition and is like the
following:

 # perf record -e cycles:ppk sleep 1
 
   Error: sys_perf_event_open() syscall returned with 22 (Invalid argument).  /bin/dmesg may provide additional information.
 
 Not all events could be opened.
 sleep: Terminated

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

