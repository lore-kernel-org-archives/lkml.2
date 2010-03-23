Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0CWQ6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:58:53 -0400
Received: from mga10.intel.com ([192.55.52.92]:16915 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752816Ab0CWQ6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:58:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,296,1267430400"; 
   d="scan'208";a="551434959"
Message-ID: <4BA8F34C.9040401@linux.intel.com>
Date: Tue, 23 Mar 2010 09:58:52 -0700
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
References: <1268399863.3407.15.camel@localhost> <4BA7773A.5080206@linux.intel.com> <1269361716.3475.1.camel@localhost> <201003231757.51259.trenn@suse.de>
In-Reply-To: <201003231757.51259.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/2010 9:57, Thomas Renninger wrote:
> On Tuesday 23 March 2010 17:28:36 Robert Schöne wrote:
>> Am Montag, den 22.03.2010, 06:57 -0700 schrieb Arjan van de Ven:
>>> On 3/22/2010 0:04, Robert Schöne wrote:
>>>> Am Sonntag, den 21.03.2010, 17:42 -0700 schrieb Arjan van de Ven:
>>>>> On 3/20/2010 14:37, Thomas Renninger wrote:
>>>>>
>>>>>> It also seem to be (hopefully) a minor feature for timechart, so this should
>>>>>> not hurt that much (yet).
>>>>>
>>>>> It's actually a major feature for timechart, and one of the key things I and a bunch of others
>>>>> inside Intel use timechart for.
>>>>>
>>>> It's a major feature for us too.
>>>> I suppose, the cpufreq_notify_transition calls are correct (meaning
>>>> being called for all related cpus) for every driver. So there's still
>>>> the option to include it in the POST_CHANGE section of this function.
>>>> Could this be okay for the both of you?
>>>
>>> post change would work... that gets frequency afaik..
>> Are you ok with this too, Thomas?
> You mean hooking it into cpufreq_stat_notifier_trans() in
> drivers/cpufreq/cpufreq_stats.c?

no


hooking into the post frequency change callback that gets done..
which is guaranteed to be on the right cpu afaics.
