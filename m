Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1HPRoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:44:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45869 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1HPRof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:44:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110725569"
Message-ID: <0446c62c2d4a2c60442c582b4f61f5d3.squirrel@www.codeaurora.org>
In-Reply-To: <4E4AA52E.1070706@codeaurora.org>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
    <201108161537.28612.arnd@arndb.de>
    <20110816135051.GA22227@huya.qualcomm.com>
    <201108161632.22255.arnd@arndb.de> <4E4AA52E.1070706@codeaurora.org>
Date: Tue, 16 Aug 2011 10:44:35 -0700 (PDT)
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: sdharia@codeaurora.org
To: "Kenneth Heitke" <kheitke@codeaurora.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "David Brown" <davidb@codeaurora.org>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        "Sagar Dharia" <sdharia@codeaurora.org>, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>>> Kenneth would better be able to clarify how dynamic the SLIMbus is.
>>
>> That would definitely be helpful. Also, I'd be very interested to hear
>> what kind of device probing is available on slimbus. If Mark was
>> right about devices being discoverable, we need don't need any board
>> description (dts or hardcoded) but instead a way to match the devices
>> to drivers based on their HW ID.
>>
>> 	Arnd
>>
>
> SLIMbus is a MIPI standard bus primarily used for digital audio devices.
>   The devices on the bus SLIMbus enumerate themselves by sending an
> IDENTITY message.  I'll let Sagar clarify further.

Thanks everyone for taking your time to review the RFC.
Regarding device discovery:
Every device sends a "PRESENT" message when it comes up. Every device has
48-bit address like Ethernet and spec lets upto 256 devices (each getting
8-bit logical address) on one bus.
The device can report anytime (when it's plugged in, when a dynamic module
powers it on etc.)
Typical use case will be to have it board-specific but as Mark
mentioned,we may have plug-in cards with slimbus devices so we want
dynamic support as well.

Thanks-
-Sagar

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


