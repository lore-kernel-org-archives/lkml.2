Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2IOTxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 15:53:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37825 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2IOTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 15:53:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6836"; a="237262723"
Message-ID: <5054DCB8.4030209@codeaurora.org>
Date: Sat, 15 Sep 2012 12:53:28 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Marc Zyngier <marc.zyngier@arm.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 1/2] ARM: arch timer: Set the TVAL before timer
 is enabled
References: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org> <20120915170026.GA8706@codeaurora.org>
In-Reply-To: <20120915170026.GA8706@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/2012 10:00 AM, David Brown wrote:
> On Sat, Sep 15, 2012 at 12:41:53AM -0700, Rohit Vaswani wrote:
>> On some hardware, the timer deasserts the interrupt when a
>> new TVAL is written only when the enable bit is cleared.
>> Hence explicitly disable the timer and then program the
>> TVAL followed by enabling the timer.
>> If this order is not followed, there are chances that
>> you would not receive any timer interrupts.
> It's a little unclear to me who you intend to take this patch.  In the
> To field, you've listed Marc, the MSM maintainers, as well as Russell.
> The MSM tree doesn't really make sense, since this is general ARM
> code.  Marc would make sense if you depend on an active patch series
> he is working on, so he could include it.
>
> I'm guessing you meant it for Russell, though, and the rest of us as
> CCs.

Yes, thanks for pointing that out. Sorry if the headers were confusing, 
I will be more mindful of this next time.
>
> Thanks,
> David
>



Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

