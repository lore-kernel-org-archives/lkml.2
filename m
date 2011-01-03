Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010Ab1ACFFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:05:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab1ACFFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:05:14 -0500
Message-ID: <4D2158C4.5010107@redhat.com>
Date: Mon, 03 Jan 2011 00:04:04 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Edwin Zhai <edwin.zhai@intel.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <AANLkTikqDDq2GWYONu=JyGkrETMATx14LCFbm+e4PSSZ@mail.gmail.com>	<4D20B38B.40007@redhat.com> <AANLkTi=hKcX5Sjei-gNjkknU9O4bZ=bxT9AuSA-US-H4@mail.gmail.com>
In-Reply-To: <AANLkTi=hKcX5Sjei-gNjkknU9O4bZ=bxT9AuSA-US-H4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2011 11:18 PM, Hillf Danton wrote:
> On Mon, Jan 3, 2011 at 1:19 AM, Rik van Riel<riel@redhat.com>  wrote:
>> On 01/02/2011 06:43 AM, Hillf Danton wrote:
>>
>>> The following work is based on what Rik posted, with a few changes.
>>
>> I threw out my patch before Christmas, replacing it with
>> Mike Galbraith's work.
>>
>
> Would you please share the work by Mike, or info where to get it?

Now that I finally got useful test results (after
increasing ple_gap to be more useful on the X5670
CPU), I will post the patch series.

Christmas holidays are a good thing, but expect
patches tomorrow :)

-- 
All rights reversed
