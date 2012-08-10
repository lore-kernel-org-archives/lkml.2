Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab2HJDgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:36:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45777 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2HJDf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:35:59 -0400
Message-ID: <50248195.9080401@zytor.com>
Date: Thu, 09 Aug 2012 20:35:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: yanmin_zhang@linux.intel.com
CC: mingo@redhat.com, tglx@linutronix.de, linx.z.chen@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [PATCH] x86/smp: Fix cpuN startup panic]
References: <1344558907.19233.3.camel@ymzhang.sh.intel.com>
In-Reply-To: <1344558907.19233.3.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 05:35 PM, Yanmin Zhang wrote:
> Peter,
>
> What's your opinion about the patch? We hit it when enabling Medfield Android mobile.
> This patch would put AP to a loop.
>
> Another method to fix it is just to enlarge the wait time, for example, from 2HZ to 10HZ.
>

Hmm... and I presume running with preemption disabled doesn't work for 
hotplug (not that this is a hotplug situation)...

2 seconds is a *long* time, but I guess there isn't really nay harm in 
making it 10 seconds in the sense that the system is basically dead at 
that point...

tglx - you have been looking at the CPU startup lately, any opinions?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

