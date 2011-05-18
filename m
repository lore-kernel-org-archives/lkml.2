Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1ERXG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:06:28 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48431 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1ERXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:06:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="92160596"
From: David Brown <davidb@codeaurora.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-msm\@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/7] msm: gpiomux: Move public API to public header
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
	<1305755453-31112-6-git-send-email-davidb@codeaurora.org>
	<0D753D10438DA54287A00B027084269764D2F7405A@AUSP01VMBX24.collaborationhost.net>
Date: Wed, 18 May 2011 16:06:26 -0700
In-Reply-To: <0D753D10438DA54287A00B027084269764D2F7405A@AUSP01VMBX24.collaborationhost.net>
	(H. Hartley Sweeten's message of "Wed, 18 May 2011 17:44:39 -0500")
Message-ID: <8yay623libx.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18 2011, H Hartley Sweeten wrote:

> On Wednesday, May 18, 2011 2:51 PM, David Brown wrote:
>>
>> The gpiomux.h header contains some SOC ifdefs.  However, the API that
>> is actually used by the GPIO driver only uses two functions that are
>> general.  Move these general definitions into a public header file.
>>
>> Signed-off-by: David Brown <davidb@codeaurora.org>
>> ---
>>  arch/arm/mach-msm/gpio.c    |    2 +-
>>  arch/arm/mach-msm/gpiomux.h |   17 +----------------
>>  include/linux/msm_gpiomux.h |   38 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 40 insertions(+), 17 deletions(-)
>>  create mode 100644 include/linux/msm_gpiomux.h
>
> The msm_gpiomux.h header appears to be very "msm" specific, especially
> with the #ifdef CONFIG_MSM_GPIOMUX in it.  Wouldn't it be cleaner to
> just move it to arch/arm/mach-msm/include/mach/msm_gpiomux.h?
>
> I don't see a reason why this header needs/should be available for
> the general public in /include/linux.

Agreed.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
