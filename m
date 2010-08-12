Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab0HLR6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:58:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65142 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab0HLR6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:58:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6072"; a="50801788"
Message-ID: <4C64363A.4080406@codeaurora.org>
Date: Thu, 12 Aug 2010 13:58:18 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Stepan Moskovchenko <stepanm@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org> <4C642E6D.6000908@codeaurora.org>
In-Reply-To: <4C642E6D.6000908@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/2010 1:25 PM, Stepan Moskovchenko wrote:
> On 8/12/2010 9:49 AM, Neil Leeder wrote:
>> +config MOUSE_QCITP
>> + tristate "Quanta Computer Inc. Touchpad"
>> + depends on I2C
>> + help
>> + This driver supports the touchpad on Quanta smartbook devices.
>> +
>> + Say Y here if you have a Quanta-based smartboot or notepad
> Sorry, very minor point - do you mean "smartbook" here?
>
> A lot of machines are made by Quanta. Should this be given a description
> / option name that is more specific, ie, "Quanta [chip name] Touchpad"
> or even "Quanta I2C Touchpad" ? What you have might be fine, however...
>

Good catch on the typo. I can update the Kconfig item to include I2C as 
you suggested.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
