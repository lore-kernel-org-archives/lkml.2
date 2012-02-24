Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2BXRcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:32:31 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9358 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2BXRc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:32:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6630"; a="163957462"
Message-ID: <4F47C9AA.5060806@codeaurora.org>
Date: Fri, 24 Feb 2012 09:32:26 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: David Brown <davidb@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] msm: timer: Support sched_clock()
References: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org> <20120222215533.GA31480@codeaurora.org> <4F476242.2020909@arm.com> <20120224170901.GA9312@codeaurora.org> <4F47C7C5.4090806@arm.com>
In-Reply-To: <4F47C7C5.4090806@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On 02/24/12 09:24, Marc Zyngier wrote:
> On 24/02/12 17:09, David Brown wrote:
>> I'll keep an eye on it then, and push it into the ARM soc tree when
>> the dependencies are there.
> The whole thing is that there's no dependency. The sched_clock() stuff
> has hit mainline during the merge window. This patch could go in right
> now, without any harm.
>
> What Russell pulled is just a cleanup to convert the last two platforms
> having their own sched_clock() and not relying on our framework.
>
>

This patch relies on the fact that the HAVE_SCHED_CLOCK config option no
longer exists. We could push it in if the patch had that option added to
the Kconfig, but then it would conflict with the removal of the Kconfig
by 6905a65 (ARM: Make the sched_clock framework mandatory, 2012-01-18).

So I guess we send it through the arm-soc tree?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

