Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946031Ab2JaV2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:28:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933646Ab2JaV2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:28:13 -0400
Message-ID: <509197D2.6000503@zytor.com>
Date: Wed, 31 Oct 2012 14:27:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: "Zhang, Jun" <jun.zhang@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Sometimes, there is OOPS happened when we use oprofile.
References: <88DC34334CA3444C85D647DBFA962C270FD7E416@SHSMSX102.ccr.corp.intel.com> <20121031210522.GB4386@ivy.homofaber>
In-Reply-To: <20121031210522.GB4386@ivy.homofaber>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 02:05 PM, Robert Richter wrote:
> Jun,
>
> On 29.10.12 02:33:54, Zhang, Jun wrote:
>> Sometimes, there is OOPS happened when we use oprofile. next
>> is the call stack. From call stack, we find in
>> call_on_stack if there is a nmi interrupt between "xchgl
>> %%ebx,%%esp" and "call *%%edi", system will OOPS.
>
> this should be related and fixed with:
>
>   https://lkml.org/lkml/2012/9/12/269
>
> Ingo, HPA,
>
> please apply the fix of kernel_stack_pointer().
>

Thanks for the reminder.  Ingo bounced this one to me for review while I 
was away and it fell between the cracks.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

