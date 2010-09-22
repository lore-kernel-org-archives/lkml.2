Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0IVRHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:07:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:20011 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab0IVRHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:07:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,218,1283756400"; 
   d="scan'208";a="839966044"
Message-ID: <4C9A37AE.2010509@linux.intel.com>
Date: Wed, 22 Sep 2010 10:06:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jean Pihet <jean.pihet@newoldbits.com>, Thomas Renninger <trenn@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com>	 <201009171736.14170.trenn@suse.de>	<20100917162412.GB3341@elte.hu>	 <201009180026.59482.trenn@suse.de>	 <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>	 <4C9A21AD.1000800@linux.intel.com>	 <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>	 <4C9A2FB3.105@linux.intel.com> <1285173835.2275.1026.camel@laptop>
In-Reply-To: <1285173835.2275.1026.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 9/22/2010 9:43 AM, Peter Zijlstra wrote:
> On Wed, 2010-09-22 at 09:32 -0700, Arjan van de Ven wrote:
>>> What are the apps that are using it? I know about builtin-timechart,
>>> pytimechart. Is powertop using this as well?
>> powertop 2.x codebase is as well.
>>
>> and a bunch of tools we have internal here at Intel.
>>
>> the thing with ABIs is that you don't know how many users you have.. at
>> least here you know the lower bound is 3 different tools that are open
>> source.
>> .... and likely many local tools that aren't.
> These tools should be smart enough to look up the tracepoint name, fail
> it its not available, read the tracepoint format, again fail if not
> compatible.
it's not very useful if none of the critical information is available.

you can't at the one hand push people to use perf for critical pieces 
(like machine checks etc etc) and on
the other hand say that it's not ABI stable and should not be used really.

In this case we're talking about basically a suprious rename of 
something that isn't really an improvement
(because it makes it harder to subscribe to only one type of event)... 
that's not a good thing.


