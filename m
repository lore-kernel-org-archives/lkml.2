Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0IVPdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:33:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:19016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab0IVPdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:33:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,407,1280732400"; 
   d="scan'208";a="327485726"
Message-ID: <4C9A21AD.1000800@linux.intel.com>
Date: Wed, 22 Sep 2010 08:33:01 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jean Pihet <jean.pihet@newoldbits.com>
CC: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>	<201009171736.14170.trenn@suse.de>	<20100917162412.GB3341@elte.hu>	<201009180026.59482.trenn@suse.de> <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
In-Reply-To: <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 9/22/2010 8:31 AM, Jean Pihet wrote:
> Hi,
>
> Here is a patch that redefines the power events API. The advantages
> are: easier maintainance of the kernel and the
> user space tools, a cleaner and more generic interface, more
> parameters for fine tracing and even documentation!
>
> Thomas, this patch has your patch above merged in ('power-trace: Use
> power_switch_state instead of power_start and power_end'). The revised
> ACPI patch is coming asap.
>
> The trace points for x86 and OMAP are also udated accordingly.
>
> The pytimechart tool needs an update for the new API. This can be done
> as soon as the kernel code gets merged in.

unfortunately this code is changing a userspace ABI... we really 
shouldn't do that if we can avoid it,
and here we can avoid it.

applications ARE using this stuff!
