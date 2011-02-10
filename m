Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1BJJlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:41:03 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:57534 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab1BJJlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:41:01 -0500
Message-ID: <4D53FFFA.40704@linux.vnet.ibm.com>
Date: Thu, 10 Feb 2011 20:40:50 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: arjan@linux.intel.com, lenb@kernel.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3 0/3] cpuidle: Cleanup pm_idle and include driver/cpuidle.c
 in-kernel
References: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com> <1297250478.13327.162.camel@laptop>
In-Reply-To: <1297250478.13327.162.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2011-02-08 at 16:21 +0530, Trinabh Gupta wrote:
>>
>>   arch/x86/kernel/process.c     |  340 -------------------------------
>>   arch/x86/kernel/process_32.c  |    4
>>   arch/x86/kernel/process_64.c  |    4
>>   arch/x86/xen/setup.c          |    1
>>   drivers/acpi/processor_idle.c |    2
>>   drivers/cpuidle/Kconfig       |    9 +
>>   drivers/cpuidle/cpuidle.c     |   43 +++-
>>   drivers/cpuidle/driver.c      |  112 ++++++++++
>>   drivers/idle/Makefile         |    2
>>   drivers/idle/default_driver.c |  453 +++++++++++++++++++++++++++++++++++++++++
>>   include/linux/cpuidle.h       |    3
>>   11 files changed, 613 insertions(+), 360 deletions(-)
>>   create mode 100644 drivers/idle/default_driver.c
>
>
> # git grep -l "\<pm_idle\>" arch/x86/
> arch/x86/kernel/apm_32.c
> arch/x86/kernel/process.c
> arch/x86/kernel/process_32.c
> arch/x86/kernel/process_64.c
> arch/x86/xen/setup.c
>
> You seemed to have missed touching apm_32.c
>

Hi Peter,

Thanks for the review. Yes, I missed this; will take care of
this and cpu_idle_wait() in the next version.

Thanks,
-Trinabh
