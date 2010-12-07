Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0LGPrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:47:33 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62377 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0LGPrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:47:32 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6189"; a="65811550"
Message-ID: <4CFE5707.6030702@codeaurora.org>
Date: Tue, 07 Dec 2010 21:17:19 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [RFC v1 PATCH 3/6] led: pmic8058: Add PMIC8058 leds driver
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-4-git-send-email-tsoni@codeaurora.org> <4CDB0451.3090303@metafoo.de> <4CDBDE5D.4040801@codeaurora.org> <4CFCE8B7.8080305@codeaurora.org> <4CFE4EAC.9000606@metafoo.de>
In-Reply-To: <4CFE4EAC.9000606@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

>>>>
>>>> If max_brightness is hardcoded in the driver you can reuse "struct led_info" and
>>>> "struct struct led_platform_data" instead of adding your own structs.
>>>
>>
>> I couldn't remove these pmic8058_led structure due to the "enum pmic8058_led id" member
>> info which I need from every led. This can be removed completely only if I abuse
>> the "flags" parameter in struct led_info to pass the led id. Let me know what you think.
> 
> Hi
> 
> I think that would be ok, other drivers seem to do the same.

Thanks. I will use "flags" parameter for "id" then and submit the re-worked version as V2.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
