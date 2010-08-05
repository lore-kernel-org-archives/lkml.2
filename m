Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab0HECBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:01:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40769 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439Ab0HECBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:01:21 -0400
Message-ID: <4C5A1B37.5070701@zytor.com>
Date: Wed, 04 Aug 2010 19:00:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: bifferos <bifferos@yahoo.co.uk>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, florian@openwrt.org, mark@bifferos.com,
        tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what
 c_ident is
References: <999475.75291.qm@web27008.mail.ukl.yahoo.com>
In-Reply-To: <999475.75291.qm@web27008.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 05:27 PM, bifferos wrote:
> 
> --- On Thu, 5/8/10, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>> Without the patch RDC is misreported as Cyrix
>> Cx486SLC.
>>>
>>
>> And what problems does that cause?  Presumably none,
> 
> If I don't know the CPU how do I set the tick rate?
> 
> http://android.git.kernel.org/?p=kernel/common.git;a=commitdiff_plain;h=e1b4d1143651fb3838be1117785b6e0386fa151f
> 

That's a valid use, of course, but that wasn't sent with it.  Even so,
it's really a chipset property and not a CPU property and probably
should simply be set via a PCI quirk.

So, clean up the patch, add the usage, and then it can be put into the
-tip tree for the next merge window.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

