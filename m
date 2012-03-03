Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2CCHmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 02:42:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab2CCHmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 02:42:23 -0500
Date: Sat, 3 Mar 2012 08:42:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [tip:perf/core] perf tools: Allow multiple threads or processes
 in record, stat, top
Message-ID: <20120303074202.GB16816@elte.hu>
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
 <tip-b52956c961be3a04182ae7b776623531601e0fb7@git.kernel.org>
 <20120302105620.GA21762@elte.hu>
 <4F50DEA0.2020607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F50DEA0.2020607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> That first cup of coffee is so important.
> 
> On 3/2/12 3:56 AM, Ingo Molnar wrote:
> >phoenix:~>  perf record -a sleep 1
> >[ perf record: Woken up 1 times to write data ]
> >[ perf record: Captured and wrote 0.023 MB perf.data (~988 samples) ]
> >phoenix:~>  perf report --stdio
> >Warning:
> >The perf.data file has no samples!
> ># ========
> ># captured on: Fri Mar  2 12:01:41 2012
> ># hostname : phoenix
> ># os release : 3.3.0-rc5+
> ># perf version : 3.3.rc5.1698.g68a63a.dirty
> ># arch : x86_64
> ># nrcpus online : 16
> ># nrcpus avail : 16
> ># cpudesc : Quad-Core AMD Opteron(tm) Processor 8356
> ># cpuid : AuthenticAMD,16,2,3
> 
> Would you mind adding this patch:
>   https://lkml.org/lkml/2012/2/29/217
> and see if it fixes your problem?

That one appears to have done the trick - I committed it 
yesterday, shortly after I did the testing - unknowing that it 
would fix this bug as well :-)

Thanks,

	Ingo
