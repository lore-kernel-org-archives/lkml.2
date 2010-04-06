Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0DFDhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 23:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab0DFDhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 23:37:31 -0400
Message-ID: <4BBAAC58.80108@redhat.com>
Date: Mon, 05 Apr 2010 23:36:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
References: <20100331145602.03A7.A69D9226@jp.fujitsu.com> <20100401151639.a030fb10.akpm@linux-foundation.org> <20100402180812.646D.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100402180812.646D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2010 05:13 AM, KOSAKI Motohiro wrote:
>>> Yeah, I don't want ignore .33-stable too. if I can't find the root cause
>>> in 2-3 days, I'll revert guilty patch anyway.
>>>
>>
>> It's a good idea to avoid fixing a bug one-way-in-stable,
>> other-way-in-mainline.  Because then we have new code in both trees
>> which is different.  And the -stable guys sensibly like to see code get
>> a bit of a shakedown in mainline before backporting it.
>>
>> So it would be better to merge the "simple" patch into mainline, tagged
>> for -stable backporting.  Then we can later implement the larger fix in
>> mainline, perhaps starting by reverting the "simple" fix.
>
> .....ok. I don't have to prevent your code maintainship. although I still
> think we need to fix the issue completely.

Agreed on the revert.

Acked-by: Rik van Riel <riel@redhat.com>

