Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab1HWXcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:32:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60673 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab1HWXcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:32:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6447"; a="112439960"
Message-ID: <4E54389C.4020600@codeaurora.org>
Date: Tue, 23 Aug 2011 17:32:44 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100722 Eudora/3.0.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org, arnd@arndb.de,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <20110823162441.4a412869.rdunlap@xenotime.net>
In-Reply-To: <20110823162441.4a412869.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 05:24 PM, Randy Dunlap wrote:
> On Wed, 10 Aug 2011 17:31:28 -0600 Kenneth Heitke wrote:
>
>> From: Sagar Dharia<sdharia@codeaurora.org>
>>
>> SLIMbus (Serial Low Power Interchip Media Bus) is a specification
>> developed by MIPI (Mobile Industry Processor Interface) alliance.
>> SLIMbus is a 2-wire implementation, which is used to communicate with
>> peripheral components like audio. Commonly used digital audio
>> interfaces such as I2S, PCM are intended for point-to-point connection
>> between application processor and single audio device and support one
>> or two channels. Adding more channels or functions is difficult
>> without increasing number of bus structures and hence pin count.
>> In parallel to audio channels, control buses such as I2C are typically
>> used for low-bandwidth control tasks.
>> SLIMbus replaces many digital audio buses and control buses by
>> providing flexible and dynamic bus-bandwidth between data-functions
>> and control-functions.
>>

>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Randy,

Thank you for reviewing the code and documentation.  We will incorporate 
your suggestions (especially appreciate the documentation comments).

thanks,
Ken


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
