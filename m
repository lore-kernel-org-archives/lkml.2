Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1CJUTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:19:36 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64971 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1CJUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:19:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6281"; a="79236029"
Message-ID: <4D793256.5070904@codeaurora.org>
Date: Thu, 10 Mar 2011 12:19:34 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] msm: 8660: Add clock control regions to iomap
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org> <1299732274-10742-2-git-send-email-sboyd@codeaurora.org> <4D78F0D8.7000408@ru.mvista.com>
In-Reply-To: <4D78F0D8.7000408@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 07:40 AM, Sergei Shtylyov wrote:
>
>> diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
>> b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
>> index 3b19b8f..ddfc85b 100644
>> --- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
>> +++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
>> @@ -53,6 +53,14 @@
>>  #define MSM_TLMM_PHYS        0x00800000
>>  #define MSM_TLMM_SIZE        SZ_16K
>>
>> +#define MSM_CLK_CTL_BASE        IOMEM(0xFA010000)
>> +#define MSM_CLK_CTL_PHYS        0x00900000
>> +#define MSM_CLK_CTL_SIZE        SZ_16K
>
>    Surrounding code separates the macro names from values by tabs, and
> you're using spaces. Should be more consistent...

Thanks, will fix.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

