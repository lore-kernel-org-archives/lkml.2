Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab1BJMUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:20:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13487 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1BJMUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:20:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6252"; a="73906286"
Message-ID: <4D53D7FE.9070206@codeaurora.org>
Date: Thu, 10 Feb 2011 17:50:14 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Anirudh Ghayal <aghayal@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC v2 PATCH 1/7] matrix_keypad: Increase the max limit of rows
 and columns
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org> <1296568063-12010-2-git-send-email-aghayal@codeaurora.org> <AANLkTimZ9UwcQp5QQjyHVsRdEAcf6+rL18mCesishPoC@mail.gmail.com>
In-Reply-To: <AANLkTimZ9UwcQp5QQjyHVsRdEAcf6+rL18mCesishPoC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 2/9/2011 1:32 PM, Eric Miao wrote:
> On Tue, Feb 1, 2011 at 9:47 PM, Anirudh Ghayal <aghayal@codeaurora.org> wrote:
>> From: Trilok Soni <tsoni@codeaurora.org>
>>
>> Some keyboard controller have support for more than
>> 16 columns and rows. Moving this value to 32.
>>
>> Cc: Eric Miao <eric.y.miao@gmail.com>
>> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
> 
> This looks good to me, as long as the bits don't exceed 256, which
> is used in the #KEY() macro. So far, 32 looks to be a sane number
> to me, unless we have further requirement to get this larger.
> 
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
> 

Are you going to pick up this patch only from the series you want us to get
it submitted it separately?

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
