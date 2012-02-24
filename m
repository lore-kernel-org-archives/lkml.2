Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2BXRY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:24:28 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59146 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2BXRY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:24:27 -0500
Message-ID: <4F47C7C5.4090806@arm.com>
Date: Fri, 24 Feb 2012 17:24:21 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] msm: timer: Support sched_clock()
References: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org> <20120222215533.GA31480@codeaurora.org> <4F476242.2020909@arm.com> <20120224170901.GA9312@codeaurora.org>
In-Reply-To: <20120224170901.GA9312@codeaurora.org>
X-Enigmail-Version: 1.3.4
X-OriginalArrivalTime: 24 Feb 2012 17:24:39.0655 (UTC) FILETIME=[30465770:01CCF319]
X-MC-Unique: 112022417242500401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/12 17:09, David Brown wrote:
> On Fri, Feb 24, 2012 at 10:11:14AM +0000, Marc Zyngier wrote:
>> On 22/02/12 21:55, David Brown wrote:
>>> On Tue, Feb 21, 2012 at 05:39:37PM -0800, Stephen Boyd wrote:
>>>> Now that sched_clock is mandatory on ARM it's simple to add
>>>> sched_clock support to the MSM timer code. Add it so that we get
>>>> more accurate sched_clock output than the jiffies based version
>>>> that's provided by default.
>>>>
>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: David Brown <davidb@codeaurora.org>
>>>
>>> Marc, are you able to pull this into your series, so they can all go
>>> in together?  If so:
>>>
>>>   Acked-by: David Brown <davidb@codeaurora.org>
>>
>> David, Stephen,
>>
>> Russell already pulled my sched_clock() patch series, so I'm not sure it
>> is actually useful for me to carry it (and there is actually no
>> dependency between this patch and the series). Maybe putting it in the
>> patch system or via armsoc would be best?
>>
>> Otherwise:
>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> I'll keep an eye on it then, and push it into the ARM soc tree when
> the dependencies are there.

The whole thing is that there's no dependency. The sched_clock() stuff
has hit mainline during the merge window. This patch could go in right
now, without any harm.

What Russell pulled is just a cleanup to convert the last two platforms
having their own sched_clock() and not relying on our framework.

	M.
-- 
Jazz is not dead. It just smells funny...

