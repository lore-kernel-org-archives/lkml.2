Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0IOUZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 16:25:42 -0400
Received: from mx1.orcon.net.nz ([219.88.242.51]:36379 "EHLO mx1.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0IOUZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 16:25:40 -0400
Cc: mingo@redhat.com, dengcheng.zhu@gmail.com, yanmin_zhang@linux.intel.com,
        gorcunov@gmail.com, fweisbec@gmail.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, eranian@googlemail.com,
        will.deacon@arm.com, lethal@linux-sh.org, davem@davemloft.net,
        mingo@elte.hu, linux-alpha@vger.kernel.org
Message-Id: <90A4CF1B-01EC-47B2-BAEC-F35385C76593@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1284473273.2275.514.camel@laptop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [tip:perf/core] perf: Rework the PMU methods
Date: Thu, 16 Sep 2010 08:25:34 +1200
References: <new-submission> <tip-a4eaf7f14675cb512d69f0c928055e73d0c6d252@git.kernel.org> <4C8B3AD3.5050309@orcon.net.nz> <1284198035.2251.29.camel@laptop> <4C8C6611.20206@orcon.net.nz>  <1284380153.2275.261.camel@laptop> <1284383927.2275.284.camel@laptop>  <4C8F4A3E.5070603@orcon.net.nz> <1284473273.2275.514.camel@laptop>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx1.orcon.net.nz on Thu, 16 Sep 2010 16:26:21 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Sep 16 16:26:22 2010
X-DSPAM-Confidence: 0.7003
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/2010, at 2:07 AM, Peter Zijlstra wrote:
> On Tue, 2010-09-14 at 22:11 +1200, Michael Cree wrote:
>>
>> [  818.575752] Unable to handle kernel paging request at virtual  
>> address
>> 0000000000000060
>> [  818.575752] perf(4935): Oops 0
>
> Does the below cure that?
>
> ---
> commit 0c67b40872326a5340cab51d79a192a5fbaeb484
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Sep 13 11:15:58 2010 +0200
>
>    perf: Fix free_event()

Yes, thanks, that's fixed it.

Cheers
Michael.

