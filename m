Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab1HPRNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:13:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12957 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1HPRNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:13:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110519044"
Message-ID: <4E4AA52E.1070706@codeaurora.org>
Date: Tue, 16 Aug 2011 11:13:18 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100722 Eudora/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: David Brown <davidb@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <201108161537.28612.arnd@arndb.de> <20110816135051.GA22227@huya.qualcomm.com> <201108161632.22255.arnd@arndb.de>
In-Reply-To: <201108161632.22255.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2011 08:32 AM, Arnd Bergmann wrote:
> On Tuesday 16 August 2011, David Brown wrote:
>> On Tue, Aug 16, 2011 at 03:37:28PM +0200, Arnd Bergmann wrote:
>
>>> This is theoretically true, but IIRC David mentioned that the bus is
>>> only present on few SoCs and has since been abandoned in favor of standard
>>> busses for new devices.
>>
>> Actually, this is a different one than the one I was mentioning at the
>> Linaro Connect.  I believe SLIMbus is more active
>> http://en.wikipedia.org/wiki/SLIMbus
>>
>> The other bus I was mentioning is called SSBI, which as far as I know
>> is only used to communicate between MSMs and certain Qualcomm
>> peripheral chips.
>
> Thanks for the clarification! I assumed these were the same thing because
> the patches were posted just after we had talked about the other one.
>
>> Kenneth would better be able to clarify how dynamic the SLIMbus is.
>
> That would definitely be helpful. Also, I'd be very interested to hear
> what kind of device probing is available on slimbus. If Mark was
> right about devices being discoverable, we need don't need any board
> description (dts or hardcoded) but instead a way to match the devices
> to drivers based on their HW ID.
>
> 	Arnd
>

SLIMbus is a MIPI standard bus primarily used for digital audio devices. 
  The devices on the bus SLIMbus enumerate themselves by sending an 
IDENTITY message.  I'll let Sagar clarify further.

thanks,
Ken


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
