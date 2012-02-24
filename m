Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2BXRiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:38:04 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39733 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2BXRiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:38:02 -0500
Message-ID: <4F47CAF5.4000709@arm.com>
Date: Fri, 24 Feb 2012 17:37:57 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] msm: timer: Support sched_clock()
References: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org> <20120222215533.GA31480@codeaurora.org> <4F476242.2020909@arm.com> <20120224170901.GA9312@codeaurora.org> <4F47C7C5.4090806@arm.com> <4F47C9AA.5060806@codeaurora.org>
In-Reply-To: <4F47C9AA.5060806@codeaurora.org>
X-Enigmail-Version: 1.3.4
X-OriginalArrivalTime: 24 Feb 2012 17:38:15.0499 (UTC) FILETIME=[168E41B0:01CCF31B]
X-MC-Unique: 112022417380000201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/12 17:32, Stephen Boyd wrote:
> Hi Marc,
> 
> On 02/24/12 09:24, Marc Zyngier wrote:
>> On 24/02/12 17:09, David Brown wrote:
>>> I'll keep an eye on it then, and push it into the ARM soc tree when
>>> the dependencies are there.
>> The whole thing is that there's no dependency. The sched_clock() stuff
>> has hit mainline during the merge window. This patch could go in right
>> now, without any harm.
>>
>> What Russell pulled is just a cleanup to convert the last two platforms
>> having their own sched_clock() and not relying on our framework.
>>
>>
> 
> This patch relies on the fact that the HAVE_SCHED_CLOCK config option no
> longer exists. We could push it in if the patch had that option added to
> the Kconfig, but then it would conflict with the removal of the Kconfig
> by 6905a65 (ARM: Make the sched_clock framework mandatory, 2012-01-18).

Ah! Indeed, you're perfectly right.

> So I guess we send it through the arm-soc tree?

I don't think arm-soc tracks rmk/for-next, so this has to go via
Russell's tree. I'll take the patch and send Russell another pull
request then.

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

