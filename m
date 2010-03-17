Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0CQQlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:41:44 -0400
Received: from mga10.intel.com ([192.55.52.92]:42691 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752682Ab0CQQlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:41:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,658,1262592000"; 
   d="scan'208";a="549867430"
Message-ID: <4BA10642.8070208@linux.intel.com>
Date: Wed, 17 Mar 2010 09:41:38 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: =?ISO-8859-15?Q?Robert_Sch=F6ne?= <robert.schoene@tu-dresden.de>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
References: <1268399863.3407.15.camel@localhost> <201003161550.18102.trenn@suse.de> <4B9FB472.5060702@linux.intel.com> <201003171736.00550.trenn@suse.de>
In-Reply-To: <201003171736.00550.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/17/2010 9:36, Thomas Renninger wrote:
> On Tuesday 16 March 2010 17:40:18 Arjan van de Ven wrote:
>> On 3/16/2010 7:50, Thomas Renninger wrote:
>>> Still, as this is totally broken:
>>>      - by design ->   only one of a dozen cpufreq drivers is supported
>>
>> the one I care about is supported.
> And that's the problem, before it's not removed, you do not care to
> provide/suggest a proper solution that could fit others as well.

why don't you provide the others then?


>> how about not. it works right now,
> It does not. Robert's fix (if he had taken the frequency) is correct.
> That means you could get totally wrong values
> when you put some load on the machine and the scheduler moves around
> processes.

the only case where the bug can hit is the userspace governor, yes.
it works correct for everything else. Yes it wants fixing. No it does not make
all data from it worthless.


>> and is in active use right now.
> It's obviously not powertop, there I get some statistics on an AMD
> machine as well. So where does it get used?

as I wrote in my previous mails... timechart.

