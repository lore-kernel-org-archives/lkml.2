Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0HZSpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:45:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23476 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0HZSpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:45:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52352088"
Message-ID: <4C76B65C.9000702@codeaurora.org>
Date: Thu, 26 Aug 2010 14:45:48 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org> <0680EC522D0CC943BC586913CF3768C003B3909F9C@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B3909F9C@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2010 4:36 AM, Datta, Shubhrajyoti wrote:
>
> Minor comments feel free to ignore if you feel so.

Thanks for reviewing this, I'll address these in the next patch.

>> +	err = i2c_master_send(context->ti2c_client, buf, 1);
>> +	if (err<  0)
>> +		goto i2c_fail;
>> +	msleep(100);
> Could you explain the time or have a #define XXX
>
Will add #define

>> +	gpio_direction_input(context->qcitp_gpio);
> The result is not checked here.

I'll check the result.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
