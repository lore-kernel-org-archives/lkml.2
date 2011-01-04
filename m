Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1ADTCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:02:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59672 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab1ADTCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:02:07 -0500
Message-ID: <4D236E47.5080500@zytor.com>
Date: Tue, 04 Jan 2011 11:00:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
References: <1293464211.2695.104.camel@localhost>	 <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>	 <1293526288.2457.4.camel@minggr.sh.intel.com>	 <1294052312.2016.50.camel@laptop> <4D222926.9010206@zytor.com>	 <1294139419.2016.115.camel@laptop>	 <AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>	 <1294148675.2016.139.camel@laptop>	 <AANLkTima_wh1Nd2E-zQAcymmux1O0e1GzVEdnhLEMOo5@mail.gmail.com> <1294149501.2016.141.camel@laptop>
In-Reply-To: <1294149501.2016.141.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 05:58 AM, Peter Zijlstra wrote:
> On Tue, 2011-01-04 at 14:52 +0100, Stephane Eranian wrote:
>>
>> Couldn't you simply over-provision, and then when the CPU is online, use my
>> ht_enabled statement to figure out whether or not you need to handle the sharing
>> issue? 
> 
> That's pretty much what Lin's latest does:
> 
>  X86_FEATURE_HT && smp_num_siblings > 1
> 
> shows the CPU is capable of HT and will allocate the needed resources.
> 

>From the sound of it, it doesn't seem like it's worth optimizing out the
fairly small memory allocation.

	-hpa

