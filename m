Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0KKTif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:38:35 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44441 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab0KKTie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:38:34 -0500
Message-ID: <4CDC4628.8020109@linux.vnet.ibm.com>
Date: Thu, 11 Nov 2010 11:38:16 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        acme@redhat.com, eranian@google.com
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org> <1289492117-18066-2-git-send-email-andi@firstfloor.org> <4CDC2DDD.50508@linux.vnet.ibm.com> <4CDC3845.4030104@linux.intel.com>
In-Reply-To: <4CDC3845.4030104@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 10:39 AM, Andi Kleen wrote:
>
>> It's not clear to me that a comma is the best character to use in this
>> instance, because multiple events can be listed after the -e separated
>> by commas as well, for example: -e rXXXX,cycles.
>> -e rXXXX,YYYY,cycles would be confusing to read.
>>
>> How about -e rXXXX[+YYYY]
>
> That's a good point. The comma seems to work in my testing though for
> some reason, but I guess
> I broke the multiple events case then. I'll switch over to +
>
> -Andi
>


I think it would have parsed OK, but it is a confusing syntax to look 
at.  I should point out that there are also the u,k,h modifiers which 
can be specified, even on raw events, so the full syntax looks something 
like:

-e rXXXX[+YYYY][:u|:k|:h]

- Corey
