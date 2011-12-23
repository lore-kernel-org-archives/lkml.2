Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1LWKfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:35:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41012 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab1LWKf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:35:28 -0500
Date: Fri, 23 Dec 2011 11:33:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf script: Add script to collect and display IBS
 samples
Message-ID: <20111223103329.GC4749@elte.hu>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
 <1323969824-9711-5-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323969824-9711-5-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> This patch adds a script to collect and display IBS samples.
> There are the following options:
> 
>  perf script ibs [ibs_op|ibs_fetch] [-c period] <command>
> 
> Examples for usage:
> 
>  perf script ibs ibs_op <command>
>  perf script ibs ibs_fetch <command>
>  perf script record ibs ibs_op -c 500000 <command>
>  perf script report ibs
>  perf script record ibs ibs_op -c 500000 <command> | perf script report ibs

So, cannot we just integrate this into regular perf record and 
perf report?

Also, could you quote example output of "perf script report ibs"?

Thanks,

	Ingo
