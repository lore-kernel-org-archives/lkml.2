Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2JUCk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 22:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab2JUCk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 22:40:27 -0400
Message-ID: <5083608E.6040209@redhat.com>
Date: Sat, 20 Oct 2012 22:40:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ni zhan Chen <nizhan.chen@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: question on NUMA page migration
References: <5081777A.8050104@redhat.com> <50836060.4050408@gmail.com>
In-Reply-To: <50836060.4050408@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 10:39 PM, Ni zhan Chen wrote:
> On 10/19/2012 11:53 PM, Rik van Riel wrote:
>> Hi Andrea, Peter,
>>
>> I have a question on page refcounting in your NUMA
>> page migration code.
>>
>> In Peter's case, I wonder why you introduce a new
>> MIGRATE_FAULT migration mode. If the normal page
>> migration / compaction logic can do without taking
>> an extra reference count, why does your code need it?
>
> Hi Rik van Riel,
>
> This is which part of codes? Why I can't find MIGRATE_FAULT in latest
> v3.7-rc2?

It is in tip.git in the numa/core branch.


-- 
All rights reversed
