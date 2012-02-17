Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2BQWMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:12:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:50288 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab2BQWMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:12:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108062033"
Message-ID: <4F3ED0C1.80907@linux.intel.com>
Date: Fri, 17 Feb 2012 14:12:17 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf, x86: Disable PEBS on SandyBridge chips
References: <4F3E4A7A.1070708@gmail.com> <1329491549.2293.275.camel@twins> <4F3EC931.2080106@linux.intel.com> <4F3ECFC7.4010607@gmail.com>
In-Reply-To: <4F3ECFC7.4010607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 02:08 PM, David Ahern wrote:
> On 2/17/12 2:40 PM, H. Peter Anvin wrote:
>> On 02/17/2012 07:12 AM, Peter Zijlstra wrote:
>>> On Fri, 2012-02-17 at 13:39 +0100, Maarten Lankhorst wrote:
>>>> Hey Peter,
>>>>
>>>> Why is PEBS disabled? If I look at the intel_clovertown_quirks I can
>>>> see
>>>> why it's disabled for that cpu, but the sandy bridge one lacks any kind
>>>> of clarification or information on why, or how I can learn more.
>>>
>>> hpa, could you get the official Intel answer on this?
>>
>> *Where* is PEBS disabled?
>
> arch/x86/kernel/cpu/perf_event_intel.c,
> intel_sandybridge_quirk()
>

OK, this is Peter's patch and I don't think I was involved with it... I 
need more of a pointer to be able to track this down.

	-hpa


