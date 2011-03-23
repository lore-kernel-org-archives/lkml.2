Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab1CWUmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:42:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51009 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404Ab1CWUmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6294"; a="81469415"
Message-ID: <4D8A5B44.9050306@codeaurora.org>
Date: Wed, 23 Mar 2011 13:42:44 -0700
From: Carl Vanderlip <carlv@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/20] video: msm: Split out MDP2.2 HW specific code.
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>	 <1300485423-27281-1-git-send-email-carlv@codeaurora.org> <1300885912.6117.16.camel@m0nster>
In-Reply-To: <1300885912.6117.16.camel@m0nster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 06:11 AM, Daniel Walker wrote:
> On Fri, 2011-03-18 at 14:57 -0700, Carl Vanderlip wrote:
>> index df9d74e..d6e75c3 100644
>> --- a/arch/arm/mach-msm/Kconfig
>> +++ b/arch/arm/mach-msm/Kconfig
>> @@ -76,6 +76,11 @@ config HAS_MSM_DEBUG_UART_PHYS
>>  config  MSM_VIC
>>         bool
>>  
>> +config MSM_MDP22
>> +       bool
>> +       depends on ARCH_MSM7X00A
>> +       default y
>> + 
> You should remove the "default y" and this should be moved to a Kconfig
> under video (shouldn't be added into mach-msm).
>
> Daniel
>
What about removing the 'depends on' and 'default y' and making it be
selected by MSM7X00A?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

