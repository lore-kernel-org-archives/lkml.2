Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2FLUEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:04:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35833 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2FLUEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:04:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6740"; a="200337857"
Message-ID: <877b9088e2763c57e24f9931b5839a3e.squirrel@www.codeaurora.org>
In-Reply-To: <x491ulkk4cb.fsf@segfault.boston.devel.redhat.com>
References: <1339494088-29126-1-git-send-email-merez@codeaurora.org>
    <1339494088-29126-2-git-send-email-merez@codeaurora.org>
    <x491ulkk4cb.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 12 Jun 2012 13:04:08 -0700 (PDT)
Subject: Re: [PATCH 1/1] block: Add eMMC4.5 packed commands unit-tests
From: merez@codeaurora.org
To: "Jeff Moyer" <jmoyer@redhat.com>
Cc: "Maya Erez" <merez@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Lee Susman" <lsusman@codeaurora.org>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, June 12, 2012 7:11 am, Jeff Moyer wrote:
> Maya Erez <merez@codeaurora.org> writes:
>
>> Expose the following packed commands tests:
>> - Test the write packed commands list preparation
>> - Simulate a returned error code
>> - Send an invalid packed command to the card
>>
>> Signed-off-by: Lee Susman <lsusman@codeaurora.org>
>> Signed-off-by: Maya Erez <merez@codeaurora.org>
>>
>> diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
>> index 3b1f783..bbe8cac 100644
>> --- a/drivers/mmc/card/Kconfig
>> +++ b/drivers/mmc/card/Kconfig
>> @@ -67,3 +67,14 @@ config MMC_TEST
>>
>>  	  This driver is only of interest to those developing or
>>  	  testing a host driver. Most people should say N here.
>> +
>> +config MMC_BLOCK_TEST
>> +	tristate "MMC block test"
>> +	depends on MMC_BLOCK && IOSCHED_TEST
>
> Umm, if this depends on your iosched-test patch, then you should make
> them both part of a patch series.  It would have answered one of my
> questions on that patch.
>
> Cheers,
> Jeff
>
I will combine them in the next patch.

Thanks,
Maya Erez

-- 
Sent by consultant of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

