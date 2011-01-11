Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1AKHZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 02:25:10 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11291 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1AKHZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 02:25:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6222"; a="70010262"
Message-ID: <4D2C05C2.9040705@codeaurora.org>
Date: Tue, 11 Jan 2011 12:54:50 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rakesh Iyer <riyer@nvidia.com>
CC: "jj@chaosbits.net" <jj@chaosbits.net>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com> <4D2B71CB.1060004@codeaurora.org> <1FC56210173BB445BD77F608D6FB8D03165A00805E@HQMAIL03.nvidia.com>
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D03165A00805E@HQMAIL03.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakesh,

On 1/11/2011 2:41 AM, Rakesh Iyer wrote:
> Thanks for the review.
> 
> A quick response regarding the following comment.
> 
>>
>>> +
>>> +#include <linux/module.h>
>>> +#include <linux/input.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/io.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/clk.h>
>>> +#include <linux/slab.h>
>>> +#include <mach/clk.h>
>>
>> You may not need this.
>>
> 
> The mach/clk.h file contains declarations for tegra_periph_reset_assert and tegra_periph_reset_deassert which are needed.

It is really bad if it can't be addressed through clk framework. I will check this, but this
keyboard controller is on-chip so we should be fine I guess.

I hope that these APIs are not required for device drivers which are on external bus like I2C.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
