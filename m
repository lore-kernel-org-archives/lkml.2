Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0IVPgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:36:08 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41778 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab0IVPgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:36:06 -0400
MIME-Version: 1.0
X-Originating-IP: [81.241.220.68]
In-Reply-To: <4C9A21AD.1000800@linux.intel.com>
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>
	<201009171736.14170.trenn@suse.de>
	<20100917162412.GB3341@elte.hu>
	<201009180026.59482.trenn@suse.de>
	<AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
	<4C9A21AD.1000800@linux.intel.com>
Date: Wed, 22 Sep 2010 17:36:04 +0200
Message-ID: <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 5:33 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>  On 9/22/2010 8:31 AM, Jean Pihet wrote:
>>
>> Hi,
>>
>> Here is a patch that redefines the power events API. The advantages
>> are: easier maintainance of the kernel and the
>> user space tools, a cleaner and more generic interface, more
>> parameters for fine tracing and even documentation!
>>
>> Thomas, this patch has your patch above merged in ('power-trace: Use
>> power_switch_state instead of power_start and power_end'). The revised
>> ACPI patch is coming asap.
>>
>> The trace points for x86 and OMAP are also udated accordingly.
>>
>> The pytimechart tool needs an update for the new API. This can be done
>> as soon as the kernel code gets merged in.
>
> unfortunately this code is changing a userspace ABI... we really shouldn't
> do that if we can avoid it,
> and here we can avoid it.
>
> applications ARE using this stuff!
What are the apps that are using it? I know about builtin-timechart,
pytimechart. Is powertop using this as well?

Is it better to go for a 3 steps approach (add new API, change tools,
deprecate old API) like proposed above?

Thanks,
Jean
