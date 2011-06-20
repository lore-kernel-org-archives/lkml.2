Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1FTX1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:27:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5132 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab1FTX1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:27:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6383"; a="98763905"
From: David Brown <davidb@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable] [PATCH v2] msm: timer: compensate for timer shift in msm_read_timer_count
References: <1308344138-2862-1-git-send-email-johlstei@codeaurora.org>
	<20110620215922.GA21909@kroah.com>
Date: Mon, 20 Jun 2011 16:27:16 -0700
In-Reply-To: <20110620215922.GA21909@kroah.com> (Greg KH's message of "Mon, 20
	Jun 2011 14:59:22 -0700")
Message-ID: <8ya7h8gozhn.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20 2011, Greg KH wrote:

> On Fri, Jun 17, 2011 at 01:55:38PM -0700, Jeff Ohlstein wrote:
>> Some msm targets have timers whose lower bits are unreliable. So, we
>> present our timers as lower frequency than they actually are, and ignore
>> the bottom 5 bits on such targets. This compensation was erroneously
>> removed from the msm_read_timer_count function, so restore it.
>> 
>> This was broken by 94790ec25 "msm: timer: SMP timer support for msm".
>> 
>> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
>> ---
>>  arch/arm/mach-msm/timer.c |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>> 
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
>
> </formletter>

I don't think this patch was intended for stable in the first place.
Jeff, this is a fix for 3.0-rcx, right?

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
