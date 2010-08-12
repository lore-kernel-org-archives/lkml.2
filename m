Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab0HLOgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:36:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32507 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab0HLOgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:36:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6071"; a="50646853"
Message-ID: <4C6406D8.2090401@codeaurora.org>
Date: Thu, 12 Aug 2010 20:06:08 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Neil Leeder <nleeder@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 1/1] mouse: add qci touchpad driver
References: <1281126776-20014-1-git-send-email-nleeder@codeaurora.org> <4C5D3926.6050307@codeaurora.org> <20100810232014.GB21240@huya.qualcomm.com>
In-Reply-To: <20100810232014.GB21240@huya.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 8/11/2010 4:50 AM, David Brown wrote:
> On Sat, Aug 07, 2010 at 04:14:54PM +0530, Trilok Soni wrote:
> 
>>> +
>>> +/*
>>> + * Driver communicates over i2c to nuvoTon WPCE775x Embedded Controller,
>>> + * which has touchpad attached through PS/2 interface.
>>> + */
>>
>> Why this driver is not developed through MFD architecture then? nuvoTon chip
>> looks like multi-function chip, isn't it?
> 
> It is, in the sense that it does multiple things.  But, for this
> particular device, it makes the keyboard available as an i2c device.
> I don't see any particular reason to tie that to other functionality
> that the chip provides.

Ok, agreed. Neil, please submit a new patch with addressing other comments. Thanks.

---Trilok Soni
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
