Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2BQWIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:08:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61279 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2BQWIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:08:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.212.130 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
Message-ID: <4F3ECFC7.4010607@gmail.com>
Date: Fri, 17 Feb 2012 15:08:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf, x86: Disable PEBS on SandyBridge chips
References: <4F3E4A7A.1070708@gmail.com> <1329491549.2293.275.camel@twins> <4F3EC931.2080106@linux.intel.com>
In-Reply-To: <4F3EC931.2080106@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/12 2:40 PM, H. Peter Anvin wrote:
> On 02/17/2012 07:12 AM, Peter Zijlstra wrote:
>> On Fri, 2012-02-17 at 13:39 +0100, Maarten Lankhorst wrote:
>>> Hey Peter,
>>>
>>> Why is PEBS disabled? If I look at the intel_clovertown_quirks I can see
>>> why it's disabled for that cpu, but the sandy bridge one lacks any kind
>>> of clarification or information on why, or how I can learn more.
>>
>> hpa, could you get the official Intel answer on this?
>
> *Where* is PEBS disabled?

arch/x86/kernel/cpu/perf_event_intel.c,
intel_sandybridge_quirk()

David
