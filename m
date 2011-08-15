Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1HOUMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:12:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42591 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1HOUMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:12:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6439"; a="110251506"
Message-ID: <4E497DA0.7030408@codeaurora.org>
Date: Mon, 15 Aug 2011 14:12:16 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100722 Eudora/3.0.4
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, davidb@codeaurora.org,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>, rdunlap@xenotime.net,
        john.stultz@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        ohad@wizery.com, gregkh@suse.de, stefanr@s5r6.in-berlin.de,
        lethal@linux-sh.org, linville@tuxdriver.com, zajec5@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <20110815193724.GB2465@flint.arm.linux.org.uk>
In-Reply-To: <20110815193724.GB2465@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 01:37 PM, Russell King wrote:
> On Wed, Aug 10, 2011 at 05:31:28PM -0600, Kenneth Heitke wrote:
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
>> The framework supports message APIs, channel scheduling for SLIMbus.
>> Message APIs are used for status/control type of communication with a
>> device. Data Channel APIs are used for setting data channels between
>> SLIMbus devices.
>>
>> Framework supports multiple busses (1 controller per bus) and multiple
>> clients/slave devices per controller.
>
> This looks like another bus doing the same thing as SPI and I2C.
>
...
>
> I heard of another bus type at the recent Linaro conference which sounds
> like it's going to do yet again a similar thing.  So it sounds like we're
> heading for about four of these things.
>
> Is there any way to consolidate this before we end up with four ways of
> solving the same problem?
>

I agree and am certainly open to suggestions.  SPMI is another MIPI 
standard bus that is likely going to fall into the same category.

thanks,
Ken

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
