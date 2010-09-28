Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0I1Vpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:45:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:22204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0I1Vph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:45:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,249,1283756400"; 
   d="scan'208";a="329796002"
Message-ID: <4CA261F4.5070803@linux.intel.com>
Date: Tue, 28 Sep 2010 14:45:24 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jean Pihet <jean.pihet@newoldbits.com>, Thomas Renninger <trenn@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Len Brown <len.brown@intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009222049.18154.rjw@sisk.pl> <AANLkTinJU5+s_1S6i4GpRuiOfsAPiL9UFtrxCCbtoumt@mail.gmail.com> <201009282322.16291.rjw@sisk.pl>
In-Reply-To: <201009282322.16291.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 9/28/2010 2:22 PM, Rafael J. Wysocki wrote:
> On Tuesday, September 28, 2010, Jean Pihet wrote:
>> Hi,
> Hi,
>
>> Here is what I am proposing, in reply to all your comments:
>>
>> 1) rename the events to match Thomas's proposal:
>>     power:power_cpu_cstate
>>     power:power_cpu_pstate
>>     power:power_cpu_sstate
> If that sstate thing is going to mean "suspend", then please drop it.
> "Suspend" is not a state, let alone a CPU state.  It is a procedure by which
> the (entire) system is put into a sleep state (that is not confined to CPUs).

there are also non-suspend S states, like S0i1 and S0i3 (supported in 
the current Intel "Moorestown" platform)

so it's slightly more complex than "just" suspend :)

