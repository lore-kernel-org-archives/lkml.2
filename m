Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab2FETIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:08:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45029 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2FETIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:08:35 -0400
Message-ID: <4FCE592F.80809@gmail.com>
Date: Tue, 05 Jun 2012 13:08:31 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: git bisect and perf
References: <4FCE25C6.2080601@gmail.com> <1338912052.2749.2.camel@twins> <1338912312.2749.6.camel@twins> <4FCE3DE3.9060805@gmail.com> <CABPqkBSR6VCypKXoArPpvKBEpkY0MaPUmLnL7J0tOqgi8WAYzw@mail.gmail.com>
In-Reply-To: <CABPqkBSR6VCypKXoArPpvKBEpkY0MaPUmLnL7J0tOqgi8WAYzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/12 1:04 PM, Stephane Eranian wrote:
>> I'm referring to cycles:p
>>
>> model name      : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
> That's not as helpful as /proc/cpuinfo. I suspect this is a Westmere
> system, isn't it?
>


Yes:
processor	: 15
vendor_id	: GenuineIntel
cpu family	: 6
model		: 44
model name	: Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
stepping	: 2
cpu MHz		: 2394.133
cache size	: 12288 KB

[    0.146055] Performance Events: PEBS fmt1+, Westmere events, Intel 
PMU driver.
[    0.146645] ... version:                3
[    0.146897] ... bit width:              48
[    0.147150] ... generic registers:      4
[    0.147404] ... value mask:             0000ffffffffffff
[    0.147657] ... max period:             000000007fffffff
[    0.147907] ... fixed-purpose events:   3
[    0.148158] ... event mask:             000000070000000f
