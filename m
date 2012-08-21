Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2HULUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:20:54 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:57589 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756940Ab2HULUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120821104744.GV10347@arwen.pp.htv.fi>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
	<1345545940-2232-4-git-send-email-sourav.poddar@ti.com>
	<20120821104744.GV10347@arwen.pp.htv.fi>
Date: Tue, 21 Aug 2012 16:50:50 +0530
Message-ID: <CAKdam54=+vn7YepPoDVkKaXm+0cxGNZ=w4v-eYbW4VtmWxmYBQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm/dts: omap5-evm: Add keypad support
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: balbi@ti.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 21, 2012 at 4:17 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Aug 21, 2012 at 04:15:39PM +0530, Sourav Poddar wrote:
>> Add keypad data node in omap5-evm.
>>
>> Based on I2C support patch for omap5, which has been
>> already posted as a different series.
>>
>> Cc: Benoit Cousson <b-cousson@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Tested on omap5430 sdp with 3.5 custom kernel.
>>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>
> after fixing my only comment below, you can add my:
>
> Acked-by: Felipe Balbi <balbi@ti.com>
>
>> ---
>>  arch/arm/boot/dts/omap5-evm.dts |   95 +++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 95 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-evm.dts
>> index 200c39a..6473983 100644
>> --- a/arch/arm/boot/dts/omap5-evm.dts
>> +++ b/arch/arm/boot/dts/omap5-evm.dts
>> @@ -18,3 +18,98 @@
>>               reg = <0x80000000 0x40000000>; /* 1 GB */
>>       };
>>  };
>> +
>> +&i2c5 {
>> +     clock-frequency = <400000>;
>> +
>> +     smsc@38 {
>> +             compatible = "smsc";
>> +             reg = <0x38>;
>> +             clock = <0x13>;
>> +             keypad {
>> +                     compatible = "smsc,keypad";
>> +                     interrupt-parent = <&gpio5>;
>> +                     interrupts = <23>; /* gpio line 151 */
>> +                     keypad,num-rows = <8>;
>> +                     keypad,num-columns = <16>;
>> +                     linux,keymap = < 0x20041 /*KEY_F7*/
>
> please add spaces around /* and */ so it's easier to read. Ditto to all
> others.
>
Yes, will add spaces in the new version.
> --
> balbi
