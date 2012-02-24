Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2BXKLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:11:35 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53839 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2BXKLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:11:34 -0500
Message-ID: <4F476242.2020909@arm.com>
Date: Fri, 24 Feb 2012 10:11:14 +0000
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
References: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org> <20120222215533.GA31480@codeaurora.org>
In-Reply-To: <20120222215533.GA31480@codeaurora.org>
X-Enigmail-Version: 1.3.4
X-OriginalArrivalTime: 24 Feb 2012 10:11:33.0884 (UTC) FILETIME=[AF8C5BC0:01CCF2DC]
X-MC-Unique: 112022410113009101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/12 21:55, David Brown wrote:
> On Tue, Feb 21, 2012 at 05:39:37PM -0800, Stephen Boyd wrote:
>> Now that sched_clock is mandatory on ARM it's simple to add
>> sched_clock support to the MSM timer code. Add it so that we get
>> more accurate sched_clock output than the jiffies based version
>> that's provided by default.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: David Brown <davidb@codeaurora.org>
> 
> Marc, are you able to pull this into your series, so they can all go
> in together?  If so:
> 
>   Acked-by: David Brown <davidb@codeaurora.org>

David, Stephen,

Russell already pulled my sched_clock() patch series, so I'm not sure it
is actually useful for me to carry it (and there is actually no
dependency between this patch and the series). Maybe putting it in the
patch system or via armsoc would be best?

Otherwise:
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...

