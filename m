Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1ACJp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:45:57 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11097 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab1ACJpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:45:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6214"; a="69034320"
Message-ID: <4D219A94.8090908@codeaurora.org>
Date: Mon, 03 Jan 2011 15:14:52 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
References: <kev@cypress.com> <1293650268-1561-1-git-send-email-kev@cypress.com> <20101231115323.GA9709@polaris.bitmath.org> <4D1DD2D7.30108@codeaurora.org> <20101231135800.GA1513@polaris.bitmath.org>
In-Reply-To: <20101231135800.GA1513@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Henrik,

On 12/31/2010 7:28 PM, Henrik Rydberg wrote:
> On Fri, Dec 31, 2010 at 06:25:51PM +0530, Trilok Soni wrote:
>> Hi Henrik,
>>
>> On 12/31/2010 5:23 PM, Henrik Rydberg wrote:
>>> Hi Kevin,
>>>
>>> Thanks for the changes, it looks much better now. Some comments on the MT
>>> part inline.
>>>
>>>> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
>>>> index 06ea8da..7d886bc 100644
>>>> --- a/drivers/input/touchscreen/Kconfig
>>>> +++ b/drivers/input/touchscreen/Kconfig
>>>> @@ -124,6 +124,11 @@ config TOUCHSCREEN_CY8CTMG110
>>>>  	  To compile this driver as a module, choose M here: the
>>>>  	  module will be called cy8ctmg110_ts.
>>>>  
>>>> +config TOUCHSCREEN_CYTTSP_CORE
>>>> +	bool "Cypress TTSP touchscreen core"
>>>> +	help
>>>> +	  Always activated for Cypress TTSP touchscreen
>>>> +
>>>
>>> Tristate please.
>>
>> This code is just exporting APIs and doesn't need to be modular. No module_init/exit etc.,
> 
> Any particular reason why "grep cytt /proc/kallsyms | wc" should be
> non-zero when no suitable hardware is available?
> 

Ok. Let's make it tristate then. Thanks.

---Trilok Soni


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
