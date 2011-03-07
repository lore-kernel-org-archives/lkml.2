Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1CGIkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:40:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33232 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1CGIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:40:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nrBwiE64UcD71i/21hmwhdCFjCQ9/hoLUS6I02qBnMR3g7SxJDnZ8kFGnspMHNo96t
         xOlF5//UJKzNmJ4txK/N2qWhLE/CsDPDmPotzvKL4l3nAgoo6921Y2BS8dKrJ9VArXVv
         RWz0O3RfEkkjPL9ckKS5Ec/b1CHg+kjU3gnXo=
Message-ID: <4D749A09.1060901@gmail.com>
Date: Mon, 07 Mar 2011 11:40:41 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: P4 PMU -- Address erratum 15 and 17
References: <4D7141FC.8000504@gmail.com> <1299334487.2324.1.camel@localhost>	 <4D724D95.3060808@gmail.com> <1299486452.2908.47.camel@minggr.sh.intel.com>
In-Reply-To: <1299486452.2908.47.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 11:27 AM, Lin Ming wrote:
> On Sat, 2011-03-05 at 22:49 +0800, Cyrill Gorcunov wrote:
>> On 03/05/2011 05:14 PM, Lin Ming wrote:
>>> On Sat, 2011-03-05 at 03:48 +0800, Cyrill Gorcunov wrote:
>>>> Errata N15 and 17 of 249199-071 should be taken
>>>> into account. They are mostly hard to hit at moment
>>>> i believe but still better to be fixed.
>>>>
>>>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>>>> ---
>>>>
>>>> Ming, mind to give it a shot? I seems will be able to test myself
>>>> at Wednesday only. And I would like to get a review first to eliminate
>>>> some silly mistakes ;)
>>>
>>> I'll test this next Monday when I back to office.
>>>
>>> Thanks.
>>>
>>
>> Great, no hurry.
> 
> This patch causes problem.
> 

Thanks Ming, i'll investigate.

-- 
    Cyrill
