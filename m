Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2BCHjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:39:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44598 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2BCHjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:39:24 -0500
Message-ID: <4F2B8F21.6030903@gmail.com>
Date: Fri, 03 Feb 2012 15:39:13 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [Patch] avr32: select GENERIC_ATOMIC64
References: <1328252580-2630-1-git-send-email-xiyou.wangcong@gmail.com> <20120203073620.GA13215@samfundet.no>
In-Reply-To: <20120203073620.GA13215@samfundet.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 03:36 PM, Hans-Christian Egtvedt wrote:
> Around Fri 03 Feb 2012 15:03:00 +0800 or thereabout, Cong Wang wrote:
>> avr32 doesn't implement atomic64_ operations, if not select this,
>> we would get:
>>
>> kernel/trace/trace_clock.c:117: error: syntax error before 'trace_counter'
>> kernel/trace/trace_clock.c:126: error: implicit declaration of function 'atomic64_add_return'
>>
>> Cc: Haavard Skinnemoen<hskinnemoen@gmail.com>
>> Cc: Hans-Christian Egtvedt<egtvedt@samfundet.no>
>> Signed-off-by: WANG Cong<xiyou.wangcong@gmail.com>
>
> Thanks Cong, but Fabio beat you to it; https://lkml.org/lkml/2012/2/2/406
>
> The above patch (similar to yours), was just pulled into Andrews tree.

Yeah, then ignore mine. :)

Thanks.
