Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab2HNKeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:34:19 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:46390 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750Ab2HNKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <502A2740.9000206@ti.com>
References: <1344852313-30484-1-git-send-email-sourav.poddar@ti.com>
	<502A2740.9000206@ti.com>
Date: Tue, 14 Aug 2012 16:04:16 +0530
Message-ID: <CAKdam56A+Fa2pLT2fnV3sHq--PUwjdUX1U4_4JM=_g9KWoW3kw@mail.gmail.com>
Subject: Re: [PATCHv2 0/4] Add device tree data for omap5
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Tue, Aug 14, 2012 at 3:54 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> Hi Sourav,
>
> On 08/13/2012 12:05 PM, Sourav Poddar wrote:
>> The following patch series add i2c support for omap5.
>> As well as enable I2C based devices like pressure and temperature
>> through device tree. Also add onchip keypad dts data.
>
> That series does not seems to apply on top of 3.6-rc1, what based did
> you use?
>
My Bad. Send it on top of the testing branch (3.5-rc7).
Will rebase and send it on a 3.6-rc1.
> Benoit
>
>
>>
>> Cc: Benoit Cousson <b-cousson@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>
>> Sourav Poddar (4):
>>   arm/dts: omap5-evm: Add I2C support
>>   arm/dts: omap5-evm: Add tmp102 sensor support
>>   arm/dts: omap5-evm: Add keypad data
>>   arm/dts: omap5-evm: Add bmp085 sensor support
>>
>>  arch/arm/boot/dts/omap5-evm.dts |   30 +++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/omap5.dtsi    |   40 +++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 70 insertions(+), 0 deletions(-)
>>
>
